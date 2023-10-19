//
//  UserListView.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/19.
//

import SwiftUI

struct UserListView: View {
    
    @EnvironmentObject var viewModel: UserStatusDetailViewModel
    
    @State var tabType: FollowStatusType = .followers
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
//                    ForEach(viewModel.tweets) { tweet in
//                        NavigationLink {
//                            if let user = tweet.user {
//                                ProfileView(user: user)
//                            }
//                        } label: {
//                            TweetRowView(tweet: tweet)
//                        }
//                    }
                }
            }
        }
    }
}

#Preview {
    UserListView()
}
