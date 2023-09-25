//
//  FeedView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI

struct FeedView: View {
    
    @State private var showNewTweetView = false
    @ObservedObject var viewModel = FeedViewModel()
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.tweets) { tweet in
                        TweetRowView(tweet: tweet)
                    }
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
            .padding(.vertical, 32)
        }
        // FullScreen ModalView
        .fullScreenCover(isPresented: $showNewTweetView, content: {
            // 新しいTweet投稿画面をmodalで表示
            NewTweetView()
        })
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
