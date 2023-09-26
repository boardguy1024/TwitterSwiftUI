//
//  TweetRowViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/26.
//

import Foundation

class TweetRowViewModel: ObservableObject {
    
    private let service = TweetService()
    @Published var tweet: Tweet
    
    init(tweet: Tweet) {
        self.tweet = tweet
        checkIfUserLikedTweet() // 自分がいいねを押したかどうかを反映するためのfetch
    }
    
    func likeTweet() {
        // 「♡」をタップ
        service.likeTweet(self.tweet) {
            self.tweet.didLike = true
        }
    }
    
    func unlikeTweet() {
        // 「❤︎」をタップ
        service.unlikeTweet(self.tweet) {
            self.tweet.didLike = false
        }
    }
    
    func checkIfUserLikedTweet() {
        service.checkIfUserLikedTweet(tweet) { [weak self] didLike in
            self?.tweet.didLike = didLike
        }
    }
}
