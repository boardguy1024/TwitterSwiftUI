//
//  ProfileViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var tweets = [Tweet]()
    @Published var likedTweets = [Tweet]()

    private let userService = UserService()
    private let service = TweetService()
    
    let user: User
    
    var actionButtonTitle: String {
        user.isCurrentUser ? "Edit Profile" : "Follow"
    }
    
    init(user: User) {
        self.user = user
        
        self.fetchTweets()
        self.fetchLikedTweets()
    }
    
    func tweets(forFilter filter: TweetFilterViewModel) -> [Tweet] {
        switch filter {
        case .tweets:
            return self.tweets
        case .replies:
            return self.tweets // TODO: 未実装
        case .likes:
            return self.likedTweets
        }
    }
    
    func fetchTweets() {
        guard let uid = user.id else { return }
        service.fetchTweets(forUid: uid) { [weak self] tweets in
            
            self?.tweets = tweets
            
            //自分が投稿したTweetsなので自分のuserをセット
            self?.tweets.enumerated().forEach { index, _ in
                self?.tweets[index].user = self?.user
            }
        }
    }
    
    func fetchLikedTweets() {
        guard let uid = user.id else { return }
        service.fetchLikedTweets(forUid: uid) { [weak self] tweets in
            self?.likedTweets = tweets
            
            // tweetsのそれぞれUserデータをfetch
            tweets.enumerated().forEach { index, tweet in
                self?.userService.fetchProfile(withUid: tweet.uid, completion: { user in
                    self?.likedTweets[index].user = user
                })
            }
        }
    }
    
    deinit {
        print("deinit ProfileViewModel")
    }
    
}
