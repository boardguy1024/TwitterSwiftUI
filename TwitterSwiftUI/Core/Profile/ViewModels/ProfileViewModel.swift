//
//  ProfileViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var tweets = [Tweet]()
    
    private let service = TweetService()
    
    let user: User
    
    init(user: User) {
        self.user = user
        
        self.fetchTweets()
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
}
