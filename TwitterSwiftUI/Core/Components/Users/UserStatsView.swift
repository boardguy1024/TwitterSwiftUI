//
//  UserStatsView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI

struct UserStatsView: View {
    var body: some View {
        HStack(spacing: 24) {
            HStack {
                Text("807").bold()
                    .font(.subheadline).bold()
                Text("Following")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
                                
            HStack {
                Text("6.9M").bold()
                    .font(.subheadline).bold()
                Text("Followers ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    UserStatsView()
}
