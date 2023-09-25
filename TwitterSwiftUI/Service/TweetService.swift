//
//  TweetService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Firebase

struct TweetService {
    
    func uploadTweet(caption: String, completion: @escaping (Bool) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "uid": uid,
            "caption": caption,
            "likes": 0,
            "timestamp": Timestamp(date: Date())
        ]
        
        Firestore.firestore().collection("tweets").document()
            .setData(data) { error in
                if let error = error {
                    print("DEBUG: Failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                }
                
                completion(true)
            }
    }
    
    func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        Firestore.firestore().collection("tweets")
            .order(by: "timestamp", descending: true)
            .getDocuments { snopshot, _ in
                guard let documents = snopshot?.documents else { return }
                
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self )})
                completion(tweets)
            }
    }
    
    func fetchTweets(forUid uid: String, completion: @escaping ([Tweet]) -> Void) {
        Firestore.firestore().collection("tweets")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snopshot, _ in
                guard let documents = snopshot?.documents else { return }
                
                let tweets = documents.compactMap({ try? $0.data(as: Tweet.self )})
                completion(tweets.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue()}))
            }
    }
}
