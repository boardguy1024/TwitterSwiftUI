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
    
    @Published var isFollowed = false
    
    let user: User
    
    var actionButtonTitle: String {
        user.isCurrentUser ? "Edit Profile" : isFollowed ? "フォロー中" : "フォローする"
    }
    
    init(user: User) {
        self.user = user
        
        Task {
            try await self.fetchTweets()
            try await self.checkIfUserIsFollowing()
            try await self.fetchLikedTweets()
        }
    }
    
    // MARK: From View
    func actionButtonTapped() {
        
        if user.isCurrentUser { 
            // Edit Profile

        } else {
            // Follow or Following
            Task {
                if isFollowed {
                    try await unfollow()
                } else {
                    try await follow()
                }
            }
           
        }
    }
    
    @MainActor
    private func checkIfUserIsFollowing() async throws {
        guard let uid = user.id else { return }
        self.isFollowed = try await UserService.shared.checkIfUserIsFollowing(for: uid)
    }
    
    // MARK: Privates
    
    @MainActor
    private func follow() async throws {
        guard let uid = user.id else { return }
        self.isFollowed = try await UserService.shared.followUser(uid: uid)
    }
    
    @MainActor
    func unfollow() async throws {
        guard let uid = user.id else { return }
        let unfollowed = try await UserService.shared.unfollowUser(uid: uid)
        self.isFollowed = !unfollowed
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
