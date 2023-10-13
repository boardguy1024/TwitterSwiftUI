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
            
            headerView
            
            ZStack(alignment: .bottomTrailing) {

                PagerTabView(selected: $viewModel.currentTab, tabs:
                                [
                                    TabLabel(type: .recommend),
                                    TabLabel(type: .following),
                                ]) {
                                    ForEach(FeedTabFilter.allCases) { type in
                                        FeedTabListView()
                                            .environmentObject(self.viewModel)
                                            .frame(width: UIScreen.main.bounds.width)
                                    }
                                }
                                .refreshable {
                                    Task {
                                        try await viewModel.fetchTweets()
                                    }
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
            .padding(.vertical, 6)
            .background(Color.white)
    }
    
}

extension FeedView {
    var headerView: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Button {
                        showSideMenu.toggle()
                    } label: {
                        Group {
                            if let iconUrl = viewModel.currentUser?.profileImageUrl {
                                KFImage(URL(string: iconUrl))
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFill()
                            }
                        }
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
        }
    }
}

#Preview {
    FeedView(showSideMenu: .constant(false))
}
