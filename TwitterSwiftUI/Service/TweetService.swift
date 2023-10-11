//
//  TweetService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Firebase
import FirebaseFirestore

class TweetService {
        
    static let shared = TweetService()
    
    private init() { }
    
    func uploadTweet(caption: String) async throws -> Bool {
        
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        let data: [String: Any] = [
            "uid": uid,
            "caption": caption,
            "likes": 0,
            "timestamp": Timestamp(date: Date())
        ]
        
        do {
            try await Firestore.firestore().collection("tweets").document().setData(data)
            return true
        } catch {
            print("DEBUG: Failed to upload tweet with error: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchTweets() async throws -> [Tweet] {
        let snapshot = try await Firestore.firestore()
            .collection("tweets")
            .order(by: "timestamp", descending: true)
            .getDocuments()

        return snapshot.documents.compactMap({ try? $0.data(as: Tweet.self )})
    }
    
    func fetchTweets(forUid uid: String) async throws -> [Tweet] {
        let snapshot = try await Firestore.firestore()
            .collection("tweets")
            .whereField("uid", isEqualTo: uid)
            .getDocuments()
        
        let tweets = snapshot.documents.compactMap({ try? $0.data(as: Tweet.self )})
        return tweets.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
    }
}

// MARK: - Likes

extension TweetService {
    
    // 他のユーザーのTweetの「♡」をタップ
    func likeTweet(_ tweet: Tweet) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        // tweetの likeを +1する
        try await Firestore.firestore().collection("tweets").document(tweetId).updateData(["likes": tweet.likes + 1])
        
        // likeのincrementの更新が完了したら、自分のuserに自分が likeした tweetの主のuidを保持する
        // Profile画面に likeしたtweetを表示させるため
        let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
        
        // tweetIdだけを参照できれば tweetsからtweetデータを引っ張れるので、データは空で設定
        try await userLikesRef.document(tweetId).setData([:])
    }
        
    func unlikeTweet(_ tweet: Tweet) async throws {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        guard tweet.likes > 0 else { return }
        // tweetの likeを -1する
        try await Firestore.firestore().collection("tweets").document(tweetId).updateData(["likes": tweet.likes - 1])
        let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
        
        // tweetIdだけを参照できれば tweetsからtweetデータを引っ張れるので、データは空で設定
        try await userLikesRef.document(tweetId).delete()
    }
    
    
    // tweetリストに自分がいいねを押したかどうかを反映
    func checkIfUserLikedTweet(_ tweet: Tweet) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid, let tweetId = tweet.id else { return false }
        
        let snapshot = try await Firestore.firestore().collection("users").document(uid)
            .collection("user-likes")
            .document(tweetId).getDocument()
        
        // snapshotがあれば didLike=true
        return snapshot.exists
    }
    
    func fetchLikedTweets(forUid uid: String) async throws -> [Tweet] {
        var tweets = [Tweet]()
        
        let snapshot = try await Firestore.firestore()
            .collection("users")
            .document(uid)
            .collection("user-likes")
            .getDocuments()
        
        for doc in snapshot.documents {
            let tweetId = doc.documentID
            let snapshot = try await Firestore.firestore().collection("tweets").document(tweetId).getDocument()
            if let tweet = try? snapshot.data(as: Tweet.self) {
                tweets.append(tweet)
            }
            
        }
        return tweets
    }
    
//    func fetchLikedTweets(forUid uid: String, completion: @escaping ([Tweet]) -> Void) {
//        var tweets = [Tweet]()
//        
//        Firestore.firestore().collection("users").document(uid).collection("user-likes")
//            .getDocuments { snapshot, _ in
//                guard let docs = snapshot?.documents else { return }
//                
//                docs.forEach { snapshot in
//                    let tweetId = snapshot.documentID
//                    
//                    Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
//                        guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
//                        tweets.append(tweet)
//                        
//                        // 取得ごとにcompletionで画面を表示（すべてのtweetsを取得した後に completionを実行しなくても良い）
//                        completion(tweets)
//                    }
//                }
//            }
//    }
}
