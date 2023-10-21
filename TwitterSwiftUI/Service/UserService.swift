//
//  UserService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import Firebase
import FirebaseFirestore
import Combine

class UserService {
    
    static let shared = UserService()
    
    private init() { }
    
    @MainActor
    func fetchUser(withUid uid: String) async throws -> User? {
        
        do {
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            return try snapshot.data(as: User.self)
        } catch {
            print("DEBUG: Failed fetching user data with error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchUsers() async throws -> [User] {
        do {
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        } catch {
            print("DEBUG: Failed fetching users data with error: \(error.localizedDescription)")
            return []
        }
    }
    
    // ヒットしたユーザーリストを取得
    func fetchUsers(with query: String) async throws -> [User] {
        guard !query.isEmpty else { return [] }
        
        let lowercasedQuery = query.lowercased()
        let firestore = Firestore.firestore()
        
        // Publisher for fetching users by username_lowercase
        @Sendable func usersByUsername() -> Future<[User], Error> {
            return Future { promise in
                Task {
                    do {
                        let snapshot = try await firestore.collection("users")
                            .whereField("username_lowercase", isGreaterThanOrEqualTo: lowercasedQuery)
                            .whereField("username_lowercase", isLessThan: lowercasedQuery + "\u{f8ff}")
                            .getDocuments()
                        
                        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
                        promise(.success(users))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        
        @Sendable func usersByEmail() -> Future<[User], Error> {
            return Future { promise in
                Task {
                    do {
                        let snapshot = try await firestore.collection("users")
                            .whereField("emailUsername_lowercase", isGreaterThanOrEqualTo: lowercasedQuery)
                            .whereField("emailUsername_lowercase", isLessThan: lowercasedQuery + "\u{f8ff}")
                            .getDocuments()
                        
                        let users = snapshot.documents.compactMap({ try? $0.data(as: User.self) })
                        promise(.success(users))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        
        // Use CombineLatest to fetch both username and email results and combine them
        let users = try await withThrowingTaskGroup(of: [User].self) { group in
            group.addTask { try await usersByEmail().value }
            group.addTask { try await usersByUsername().value }
            
            var combinedUsers: [User] = []
            for try await users in group {
                combinedUsers.append(contentsOf: users)
            }
            
            return combinedUsers
        }
        
        return users
    }
    
    func updateProfile(profileImage: UIImage?,
                       headerImage: UIImage?,
                       name: String?,
                       bio: String?,
                       location: String?,
                       webUrl: String?) async throws {
        guard let uid = AuthService.shared.currentUser?.id else { return }
        
        var data: [String: Any] = [:]
        
        try await tryUploadImage(dataDic: &data, uploadImage: profileImage, using: ImageUploader.uploadProfileImage, key: "profileImageUrl")
        try await tryUploadImage(dataDic: &data, uploadImage: headerImage, using: ImageUploader.uploadProfileImage, key: "profileHeaderImageUrl")
        
        addIfNotEmpty(dataDic: &data, value: name, forKey: "username")
        addIfNotEmpty(dataDic: &data, value: bio, forKey: "bio")
        addIfNotEmpty(dataDic: &data, value: location, forKey: "location")
        addIfNotEmpty(dataDic: &data, value: webUrl, forKey: "webUrl")
        
        try await Firestore.firestore().collection("users")
            .document(uid)
            .updateData(data)
        
        try await AuthService.shared.refreshCurrentUser()
        
    }
    
    // Helper functions
    
    private func tryUploadImage(dataDic: inout [String: Any],
                                uploadImage: UIImage?,
                                using uploader: (UIImage) async throws -> String?, key: String) async throws {
        
        if let image = uploadImage, let downloadUrl = try await uploader(image) {
            dataDic[key] = downloadUrl
        }
    }
    
    private func addIfNotEmpty(dataDic: inout [String: Any], value: String?, forKey key: String) {
        if let value = value, !value.isEmpty {
            dataDic[key] = value
        }
    }
}


//MARK: - Following & Followers

extension UserService {
    
    
    func fetchFollowingCount(with uid: String) async throws -> Int {
        let snapshot = try await Firestore.firestore().collection("following").document(uid).collection("user-following")
            .getDocuments()
        return snapshot.documents.count
    }
    
    
    func fetchFollowersCount(with uid: String) async throws -> Int {
        let snapshot = try await Firestore.firestore().collection("followers").document(uid).collection("user-followers")
            .getDocuments()
        return snapshot.documents.count
    }
    
    func fetchFollowers(with uid: String) async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("followers").document(uid).collection("user-followers")
            .getDocuments()
        
        var users: [User] = []
        
        for document in snapshot.documents {
            let followerId = document.documentID
            if let user = try await self.fetchUser(withUid: followerId) {
                users.append(user)
            }
        }
        return users
    }
    
    func fetchFollowing(with uid: String) async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("following").document(uid).collection("user-following")
            .getDocuments()
        
        var users: [User] = []
        
        for document in snapshot.documents {
            let followerId = document.documentID
            if let user = try await self.fetchUser(withUid: followerId) {
                users.append(user)
            }
        }
        return users
    }
    
    func checkIfUserIsFollowing(for uid: String) async throws -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return false }
        
        // followers(フォロワーたち)から該当ユーザーを探し、そのユーザーがフォローしている人に自分がいるかどうかをチェック
        do {
            let isFollowing = try await Firestore.firestore().collection("followers")
                .document(uid)
                .collection("user-followers").document(currentUserId).getDocument().exists
            return isFollowing
        } catch {
            print("Failed checkIfUserIsFollowing: \(error.localizedDescription)")
            return false
        }
    }
    
    func followUser(uid: String) async throws -> Bool {
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return false }
        do {
            // Me Follow to someone
            try await Firestore.firestore().collection("following")
                .document(currentUserId)
                .collection("user-following")
                .document(uid) // <<< follow対象の uid
                .setData([:])
            
            
            try await Firestore.firestore().collection("followers")
                .document(uid)
                .collection("user-followers")
                .document(currentUserId).setData([:])
            
            return true
        } catch {
            print("Faild FollowUser: \(error.localizedDescription) ")
            return false
        }
    }
    
    func unfollowUser(uid: String) async throws -> Bool {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return false }
        do {
            // Me Follow to someone
            try await Firestore.firestore().collection("following")
                .document(currentUserId)
                .collection("user-following")
                .document(uid).delete()
            
            try await Firestore.firestore().collection("followers")
                .document(uid)
                .collection("user-followers")
                .document(currentUserId).delete()
            
            return true
        } catch {
            print("Faild UnfollowUser: \(error.localizedDescription) ")
            return false
        }
    }
}
