//
//  FeedTabListView.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/13.
//

import SwiftUI

struct FeedTabListView: View {
    
    @EnvironmentObject var viewModel: FeedViewModel
        
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.tweets) { tweet in
                        NavigationLink {
                            if let user = tweet.user {
                                ProfileView(user: user)
                            }
                        } label: {
                            TweetRowView(tweet: tweet)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    FeedTabListView()
        .environmentObject(FeedViewModel())
}
