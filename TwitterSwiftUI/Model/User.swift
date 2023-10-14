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
    let fullname: String
    let profileImageUrl: String
    let email: String
    
    var isCurrentUser: Bool {
        Auth.auth().currentUser?.uid == id 
    }
}

extension User {
    static func decode(dic: [String: Any]?) -> User {
        
        let id = dic?["uid"] as? String
        let username = dic?["username"] as? String ?? ""
        let fullname = dic?["fullname"] as? String ?? ""
        let profileImageUrl = dic?["profileImageUrl"] as? String ?? ""
        let email = dic?["email"] as? String ?? ""
        return User(id: id, username: username, fullname: fullname, profileImageUrl: profileImageUrl, email: email)
    }
}
