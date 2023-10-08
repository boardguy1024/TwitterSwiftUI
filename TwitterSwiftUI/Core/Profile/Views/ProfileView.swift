//
//  ProfileView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    @State private var selectedFilter: TweetFilterViewModel = .tweets
    @ObservedObject var viewModel: ProfileViewModel
    // プロパティラッパー@Environmentを使用して、環境変数にアクセス
    // 環境変数は、ビュー階層全体で利用できる共有の値や設定を提供
    // presentationModeは環境変数の1つで、現在のViewの表示状態に関する情報を持っている
    @Environment(\.presentationMode) var mode
    @Namespace var animation
    
    init(user: User) {
        self.viewModel = ProfileViewModel(user: user)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            headerView
            
            actionButtons
          
            userInfoDetails
            
            tweetFilterBar
            
            tweetsview
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ProfileView(user: .init(username: "", fullname: "", profileImageUrl: "", email: ""))
}

extension ProfileView {
    
    var headerView: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.systemCyan)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Button {
                    // PresentationModeへアクセスしてdismiss
                    mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 20, height: 16)
                        .foregroundColor(.white)
                }
                
                KFImage(URL(string: viewModel.user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .offset(x: 16, y: 24)
            }

        }
        .frame(height: 96)
    }
    
    var actionButtons: some View {
        HStack(spacing: 12) {
            
            Spacer()
            
            Image(systemName: "bell.badge")
                .font(.title3)
                .padding(6)
                .overlay(Circle().stroke(Color.gray, lineWidth: 0.75))
            
            Button {
                
            } label: {
                Text(viewModel.actionButtonTitle)
                    .font(.subheadline).bold()
                    .frame(width: 120, height: 32)
                    .foregroundColor(.primary)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 0.75)
                    )
            }
        }
        .padding(.trailing)
    }
    
    var userInfoDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(viewModel.user.fullname)
                    .font(.title2).bold()
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(Color(.systemBlue))
            }
            
            Text("@\(viewModel.user.username)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Your moms favorite villain")
                .font(.subheadline)
                .padding(.vertical)
            
            HStack(spacing: 24) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text("Gotham, NY")
                }
                                    
                HStack {
                    Image(systemName: "link")
                    Text("www.thejoker.com")
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
            
            // Following / Follower
            UserStatsView()
            .padding(.vertical)
        }
        .padding(.horizontal)
    }
    
    var tweetFilterBar: some View {
        HStack {
            ForEach(TweetFilterViewModel.allCases, id: \.rawValue) { item in
                VStack {
                    Text(item.title)
                        .font(.subheadline)
                        .fontWeight(selectedFilter == item ? .semibold : .regular)
                        .foregroundStyle(selectedFilter == item ? .black : .gray)
                    
                    if selectedFilter == item {
                        Capsule()
                            .foregroundStyle(Color(.systemBlue))
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "FILTER", in: animation)
                    } else {
                        Capsule()
                            .foregroundStyle(Color(.clear))
                            .frame(height: 3)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        selectedFilter = item
                    }
                }
            }
        }
        .overlay(
            Divider()
                .offset(x: 0, y: 16)
        )
    }
    
    var tweetsview: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.tweets(forFilter: selectedFilter)) { tweet in
                    TweetRowView(tweet: tweet)
                }
            }
        }
    }
}
