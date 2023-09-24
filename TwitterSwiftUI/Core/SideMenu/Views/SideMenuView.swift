//
//  SideMenuView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                
                if let user = authViewModel.currentUser {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                    
                    Text(user.fullname)
                        .font(.headline).bold()
                    
                    Text("@\(user.username)")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                UserStatsView()
                    .padding(.vertical)
            }
            
            ForEach(SideMenuViewModel.allCases, id:\.rawValue) { item in
                switch item {
                case .profile:
                    NavigationLink {
                        ProfileView()
                    } label: {
                        SideMenuOptionRowView(viewModel: item)
                    }
                case .lists: SideMenuOptionRowView(viewModel: item)
                case .bookmarks: SideMenuOptionRowView(viewModel: item)
                case .logout:
                    Button {
                        authViewModel.signOut()
                    } label: {
                        SideMenuOptionRowView(viewModel: item)
                    }
                }
            }
            
            Spacer()

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    SideMenuView()
}

