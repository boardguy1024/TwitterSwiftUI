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
        
    var buttonTapped: (FollowStatusType) -> Void
    
    init(following: Binding<Int>,
         followers: Binding<Int>,
         buttonTapped: @escaping (FollowStatusType) -> Void) {
        _following = following
        _followers = followers
        self.buttonTapped = buttonTapped
    }
    
    var body: some View {
        HStack(spacing: 24) {
            Button {
                buttonTapped(.following)
            } label: {
                HStack {
                    Text("\(following)").bold()
                        .font(.subheadline).bold()
                        .foregroundColor(.black)
                    Text(FollowStatusType.following.title)
                        .font(.subheadline)
                }
            }
            
            Button {
                buttonTapped(.followers)
            } label: {
                HStack {
                    Text("\(followers)").bold()
                        .font(.subheadline).bold()
                        .foregroundColor(.black)
                    Text(FollowStatusType.followers.title)
                        .font(.subheadline)
                }
            }
        }
        .foregroundColor(.gray)
    }
}

#Preview {
    UserStatsView(following: .constant(100), 
                  followers: .constant(100),
                  buttonTapped: { _ in })
}
