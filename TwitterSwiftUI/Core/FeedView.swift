//
//  FeedView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI
import Kingfisher

struct FeedView: View {
    
    @Binding var showSideMenu: Bool
    
    @Namespace var animation
    @State private var showNewTweetView = false
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            NavigationHeaderView(showSideMenu: $showSideMenu, user: $viewModel.currentUser)
            
            ZStack(alignment: .leading) {
               
                PagerTabView(
                    selected: $viewModel.currentTab, tabs:
                        [
                            TabLabel(type: .recommend),
                            TabLabel(type: .following),
                        ]
                ) {
                    ForEach(FeedTabFilter.allCases) { type in
                        FeedTabListView()
                            .environmentObject(self.viewModel)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
                
                // 左エッジからDragしてSideMenuのoffsetがtriggerするように
                // 左に透明のViewを設ける
                Color.white.opacity(0.0001)
                    .frame(width: 30)
            }
            
            .refreshable {
                Task {
                    try await viewModel.fetchTweets()
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        // FullScreen ModalView
        .fullScreenCover(isPresented: $showNewTweetView, content: {
            // 新しいTweet投稿画面をmodalで表示
            NewTweetView() {
                // 投稿後は画面を更新
                Task { try await viewModel.fetchTweets() }
            }
        })
    }
    
    @ViewBuilder
    func TabLabel(type: FeedTabFilter) -> some View {
        Text(type.title)
            .font(.subheadline)
            .fontWeight(.bold)
            .padding(.horizontal, 40)
            .padding(.top, 3)
            .padding(.bottom, 6)
            .background(Color.white)
    }
    
}

#Preview {
    FeedView(showSideMenu: .constant(false))
}
