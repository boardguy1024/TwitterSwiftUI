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
}
