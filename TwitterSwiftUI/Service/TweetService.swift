//
//  TweetService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Firebase
import FirebaseFirestore

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

// MARK: - Likes

extension TweetService {
    // 他のユーザーのTweetの「♡」をタップ
    func likeTweet(_ tweet: Tweet, completion: @escaping () -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        // tweetの likeを +1する
        Firestore.firestore().collection("tweets").document(tweetId).updateData(["likes": tweet.likes + 1]) { _ in
            
            // likeのincrementの更新が完了したら、自分のuserに自分が likeした tweetの主のuidを保持する
            // Profile画面に likeしたtweetを表示させるため
            let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
            
            // tweetIdだけを参照できれば tweetsからtweetデータを引っ張れるので、データは空で設定
            userLikesRef.document(tweetId).setData([:]) { _ in
                 completion()
            }
            
        }
    }
    
    func unlikeTweet(_ tweet: Tweet, completion: @escaping () -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        guard tweet.likes > 0 else { return }
        // tweetの likeを -1する
        Firestore.firestore().collection("tweets").document(tweetId).updateData(["likes": tweet.likes - 1]) { _ in
            
            let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
            
            // tweetIdだけを参照できれば tweetsからtweetデータを引っ張れるので、データは空で設定
            userLikesRef.document(tweetId).delete { _ in
                completion()
            }
        }
    }
    
    // tweetリストに自分がいいねを押したかどうかを反映
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let tweetId = tweet.id else { return }
        
        Firestore.firestore().collection("users").document(uid)
            .collection("user-likes")
            .document(tweetId).getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                completion(snapshot.exists) // snapshotがあれば didLike=true
            }
    }
    
    func fetchLikedTweets(forUid uid: String, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        Firestore.firestore().collection("users").document(uid).collection("user-likes")
            .getDocuments { snapshot, _ in
                guard let docs = snapshot?.documents else { return }
                
                docs.forEach { snapshot in
                    let tweetId = snapshot.documentID
                    
                    Firestore.firestore().collection("tweets").document(tweetId).getDocument { snapshot, _ in
                        guard let tweet = try? snapshot?.data(as: Tweet.self) else { return }
                        tweets.append(tweet)
                        
                        // 取得ごとにcompletionで画面を表示（すべてのtweetsを取得した後に completionを実行しなくても良い）
                        completion(tweets)
                    }
                }
            }
    }
}
