//
//  FeedViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Foundation

enum FeedTabFilter: Int, CaseIterable, Identifiable {
    case recommend
    case following
    
    var title: String {
        switch self {
        case .recommend: "おすすめ"
        case .following: "フォロー中"
        }
    }
    
    var id: Int { self.rawValue }
}

class FeedViewModel: ObservableObject {
  
    @Published var tweets = [Tweet]()
    @Published var currentTab: FeedTabFilter = .recommend
    
    init() {
        Task {
            try await self.fetchTweets()
        }
    }
    
    @MainActor
    func fetchTweets() async throws {
        
        let tweets = try await TweetService.shared.fetchTweets()
        //いったん画面に表示
        self.tweets = tweets
        
        for index in tweets.indices {
            //直後にそれぞれUserデータを取得して画面表示
            self.tweets[index].user = try await UserService.shared.fetchProfile(withUid: tweets[index].uid)
        }
    }
}
