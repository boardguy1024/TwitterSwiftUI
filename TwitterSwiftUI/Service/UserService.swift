//
//  UserService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import Firebase

struct UserService {
    
    func fetchProfile(withUid uid: String, completion: @escaping (User) -> Void) {

        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("DEBUG: Failed fetching user data with error: \(error.localizedDescription)")
                return
            }
            
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("DEBUG: Failed fetching users data with error: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }

            let users = documents.compactMap({ try? $0.data(as: User.self) })
            completion(users)
        }
    }
}
