//
//  TweetRowView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI
import Kingfisher

struct TweetRowView: View {
    
    @ObservedObject var viewModel: TweetRowViewModel
    
    init(tweet: Tweet) {
        self.viewModel = TweetRowViewModel(tweet: tweet)
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                
                if let user = viewModel.tweet.user {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(user.fullname)
                                .font(.subheadline).bold()
                            
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                                .font(.caption)
                            
                            Text("2w")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        // tweet caption
                        Text(viewModel.tweet.caption)
                            .font(.subheadline)
                            // テキストの左寄せ
                            .multilineTextAlignment(.leading)
                    }
                }
                
                
            }
            
            HStack {
                Button {
                    
                } label: {
                     Image(systemName: "bubble.left")
                        .font(.subheadline)
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                     Image(systemName: "arrow.2.squarepath")
                        .font(.subheadline)
                }
                
                Spacer()
                
                if viewModel.tweet.didLike ?? false {
                    Button {
                        viewModel.unlikeTweet()
                    } label: {
                         Image(systemName: "heart.fill")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                } else {
                    Button {
                        viewModel.likeTweet()
                    } label: {
                         Image(systemName: "heart")
                            .font(.subheadline)
                    }
                }
                
                
                Spacer()
                
                Button {
                    
                } label: {
                     Image(systemName: "bookmark")
                        .font(.subheadline)
                }
            }
            .padding()
            .foregroundColor(.primary)
            
            Divider()
        }
        .padding()
    }
}

struct TweetRowView_Previews: PreviewProvider {
    static var previews: some View {
        TweetRowView(tweet: .init(caption: "", timestamp: .init(date: Date()), uid: "", likes: 0))
    }
}
