//
//  UserService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import Firebase
import FirebaseFirestore

class UserService {
    
    static let shared = UserService()
    
    private init() { }
    
    @MainActor
    func fetchProfile(withUid uid: String) async throws -> User? {
        
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
        do {
            let snapshot = try await Firestore.firestore().collection("users")
                .whereField("username_lowercase", isGreaterThanOrEqualTo: lowercasedQuery)
                .whereField("username_lowercase", isLessThan: lowercasedQuery + "\u{f8ff}")
                .getDocuments()
            
            return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        } catch {
            print("DEBUG: Failed fetchUsersWithQuery: \(error.localizedDescription)")
            return []
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
        guard let currentUserId = Auth.auth().currentUser?.uid else { return 0 }
        let snapshot = try await Firestore.firestore().collection("followers").document(uid).collection("user-followers")
            .getDocuments()
        return snapshot.documents.count
    }
    
    
    func fetchFollowers() async throws -> [User] {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return [] }

        let snapshot = try await Firestore.firestore().collection("followers").document(currentUserId).collection("user-followers")
            .getDocuments()
        
        snapshot.documents.forEach { snapshot in
            let followerId = snapshot.documentID
            
            print("id!!!!: \(followerId)")
        }
        
        return []
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
