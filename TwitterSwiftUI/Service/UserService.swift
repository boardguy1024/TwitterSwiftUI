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
    
    @MainActor
    func fetchUsers() async throws -> [User] {
        do {
            let snapshot = try await Firestore.firestore().collection("users").getDocuments()
            return snapshot.documents.compactMap({ try? $0.data(as: User.self) })
        } catch {
            print("DEBUG: Failed fetching users data with error: \(error.localizedDescription)")
            return []
        }
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
