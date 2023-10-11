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
}
