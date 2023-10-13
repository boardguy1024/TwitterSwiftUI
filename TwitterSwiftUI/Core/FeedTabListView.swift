//
//  FeedTabListView.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/13.
//

import SwiftUI

struct FeedTabListView: View {
    
    @EnvironmentObject var viewModel: FeedViewModel
    
    @State var tabType: FeedTabFilter = .recommend
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.tweets) { tweet in
                        TweetRowView(tweet: tweet)
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
