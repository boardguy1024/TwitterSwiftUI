//
//  PreviewProvider.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/08.
//

import Foundation

class PreviewProvider {
    static let shared = PreviewProvider()
    
    private init() { }
    
    let user = User(username: "username", fullname: "fullname", profileImageUrl: "profileImageUrl", email: "email")
    let message = Message(user: PreviewProvider.shared.user, dic: ["text": "テキスト"])
}
