//
//  SideMenuView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI

struct SideMenuView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                Circle()
                    .frame(width: 48, height: 48)
                
                Text("Bruce Wayne")
                    .font(.headline).bold()
                
                Text("@batman")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
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

