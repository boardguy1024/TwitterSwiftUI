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
    
    let userService = UserService()
    let service = TweetService()
    @Published var tweets = [Tweet]()
    @Published var currentTab: FeedTabFilter = .recommend
    
    init() {
        self.fetchTweets()
    }
    
    func fetchTweets() {
        
        service.fetchTweets { [weak self] tweets in
            guard let self = self else { return }
            //いったん画面に表示
            self.tweets = tweets
            //直後にそれぞれUserデータを取得して画面表示
            self.tweets.enumerated().forEach { index, tweet in
                
                self.userService.fetchProfile(withUid: tweet.uid, completion: { user in
                    self.tweets[index].user = user
                })
            }
        }
    }
}
