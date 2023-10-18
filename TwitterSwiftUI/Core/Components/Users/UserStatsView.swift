//
//  UserStatsView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI

struct UserStatsView: View {
    
    @State var following: Int
    @State var followers: Int
    
    init(following: Int, followers: Int) {
        self.following = following
        self.followers = followers
    }
    
    var body: some View {
        HStack(spacing: 24) {
            HStack {
                Text("\(following)").bold()
                    .font(.subheadline).bold()
                    .foregroundColor(.black)
                Text("フォロー中")
                    .font(.subheadline)
            }
                                
            HStack {
                Text("\(followers)").bold()
                    .font(.subheadline).bold()
                    .foregroundColor(.black)
                Text("フォロワー")
                    .font(.subheadline)
            }
        }
        .foregroundColor(.gray)

    }
}

#Preview {
    UserStatsView(following: 140, followers: 15)
}
