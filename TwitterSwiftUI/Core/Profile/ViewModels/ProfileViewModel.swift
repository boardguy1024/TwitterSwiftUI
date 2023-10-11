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
    
    let user: User
    
    var actionButtonTitle: String {
        user.isCurrentUser ? "Edit Profile" : "Follow"
    }
    
    init(user: User) {
        self.user = user
        
        Task {
            try await self.fetchTweets()
            try await self.fetchLikedTweets()
        }
        
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
    
    @MainActor
    func fetchTweets() async throws {
        guard let uid = user.id else { return }
        let tweets = try await TweetService.shared.fetchTweets(forUid: uid)
        self.tweets = tweets
        //自分が投稿したTweetsなので自分のuserをセット
        tweets.enumerated().forEach { index, _ in
            self.tweets[index].user = self.user
        }
    }
    
    @MainActor
    func fetchLikedTweets() async throws {
        guard let uid = user.id else { return }
        let likedTweets = try await TweetService.shared.fetchLikedTweets(forUid: uid)
        self.likedTweets = likedTweets
        for index in likedTweets.indices {
            // tweetsのそれぞれUserデータをfetch
            let user = try await UserService.shared.fetchProfile(withUid: tweets[index].uid)
            self.likedTweets[index].user = user
        }
    }
}
