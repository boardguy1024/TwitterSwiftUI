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
