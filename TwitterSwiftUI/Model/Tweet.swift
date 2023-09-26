//
//  Tweet.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import FirebaseFirestoreSwift
import Firebase

struct Tweet: Identifiable, Decodable {
    @DocumentID var id: String?
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var likes: Int
    
    var user: User?
    //optionalの理由は firestoreからdecode時にdidLikeがないため
    var didLike: Bool? = false
}
