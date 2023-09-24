//
//  User.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import FirebaseFirestoreSwift

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let username: String
    let fullname: String
    let profileImageUrl: String
    let email: String
}
