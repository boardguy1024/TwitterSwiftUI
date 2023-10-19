//
//  UserStatsView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI

struct UserStatsView: View {
    
    @Binding var following: Int
    @Binding var followers: Int
    
    init(following: Binding<Int>, followers: Binding<Int>) {
        _following = following
        _followers = followers
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
    UserStatsView(following: .constant(100), followers: .constant(100))
}
