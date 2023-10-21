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
    
    let user = User(username: "username",
                    profileImageUrl: "profileImageUrl",
                    profileHeaderImageUrl: "profileHeaderImageUrl",
                    email: "email",
                    bio: "",
                    location: "",
                    webUrl: "")
    let message = Message(user: PreviewProvider.shared.user, dic: ["text": "テキスト"])
}
