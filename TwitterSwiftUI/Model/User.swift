//
//  User.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable, Hashable {
    @DocumentID var id: String?
    let username: String
    let profileImageUrl: String
    let profileHeaderImageUrl: String?
    let email: String
    let bio: String?
    let location: String?
    let webUrl: String?
    
    var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == id 
    }
}

extension User {
    static func decode(dic: [String: Any]?) -> User {
        
        let id = dic?["uid"] as? String
        let username = dic?["username"] as? String ?? ""
        let profileImageUrl = dic?["profileImageUrl"] as? String ?? ""
        let profileHeaderImageUrl = dic?["profileHeaderImageUrl"] as? String
        let email = dic?["email"] as? String ?? ""
        let bio = dic?["bio"] as? String
        let location = dic?["location"] as? String
        let webUrl = dic?["webUrl"] as? String
        
        return User(id: id,
                    username: username,
                    profileImageUrl: profileImageUrl,
                    profileHeaderImageUrl: profileHeaderImageUrl,
                    email: email,
                    bio: bio,
                    location: location,
                    webUrl: webUrl
        )
    }
}
