//
//  FeedView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI

struct FeedView: View {
    
    @Binding var showSideMenu: Bool
    
    @Namespace var animation
    @State private var showNewTweetView = false
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            // Header
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button {
                            showSideMenu.toggle()
                        } label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.gray)
                                .padding(.all, 4)
                                .background(.gray.opacity(0.3))
                                .frame(width: 35, height: 35)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                    }
                    
                    xLogoSmall
                }
                .padding(.horizontal)
                                
                HStack {
                    ForEach(FeedTabFilter.allCases) { tab in
                        VStack(spacing: 0) {
                            Text(tab.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .frame(height: 35)
                                .foregroundStyle(viewModel.currentTab == tab ? .black : .gray)
                            
                            if viewModel.currentTab == tab {
                                Capsule()
                                    .fill(Color(.systemBlue))
                                    .frame(maxWidth: .infinity)
                                    .matchedGeometryEffect(id: "FEED_TAB", in: animation)
                                    .frame(height: 3)
                                    .padding(.horizontal, 50)
                            } else {
                                Capsule()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 3)
                                    .opacity(0)
                                    .padding(.horizontal, 50)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.spring) {
                                viewModel.currentTab = tab
                            }
                        }
                    }
                }
                .overlay(Divider(), alignment: .bottom)
            }
            
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
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
                .refreshable {
                    viewModel.fetchTweets()
                }
                
                Button {
                    showNewTweetView.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .background(
                    Circle()
                        .fill(Color(.systemBlue))
                        .frame(width: 54, height: 54)
                )
                .padding(.trailing, 32)
                .padding(.bottom, 32)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        // FullScreen ModalView
        .fullScreenCover(isPresented: $showNewTweetView, content: {
            // 新しいTweet投稿画面をmodalで表示
            NewTweetView() {
                // 投稿後は画面を更新
                viewModel.fetchTweets()
            }
        })
    }
}

#Preview {
    FeedView(showSideMenu: .constant(false))
}
