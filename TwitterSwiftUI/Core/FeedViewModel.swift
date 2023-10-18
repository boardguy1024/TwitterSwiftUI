//
//  FeedViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import SwiftUI
import Combine

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
    @Published var currentTab: Int = FeedTabFilter.recommend.rawValue
    @Published var currentUser: User?
    @Published var showUserProfile: Bool = false
    @Published var showUserStatusDetail: Bool = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
        
        Task {
            try await self.fetchTweets()
        }
    }
    
    private func setupSubscribers() {
        AuthService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }
        .store(in: &cancellable)
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
