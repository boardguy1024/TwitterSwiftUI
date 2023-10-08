//
//  SideMenuView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {

    @StateObject var viewModel: SideMenuViewModel
    @Binding var showSideMenu: Bool

    init(showSideMenu: Binding<Bool>) {
        _showSideMenu = showSideMenu
        _viewModel = .init(wrappedValue: SideMenuViewModel())
    }

    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading) {
                
                if let url = viewModel.user?.profileImageUrl {
                    KFImage(URL(string: url))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                }
                
                Text(viewModel.user?.fullname ?? "")
                    .font(.headline).bold()
                
                Text("@\(viewModel.user?.username ?? "")")
                    .font(.caption)
                    .foregroundStyle(.gray)
                
                UserStatsView()
                    .padding(.vertical)
            }
            
            ForEach(SideMenuListType.allCases, id: \.self) { type in
                switch type {
                case .profile:
                    NavigationLink {
                        if let user = viewModel.user {
                            ProfileView(user: user)
                        }
                    } label: {
                        SideMenuOptionRowView(type: type)
                    }
                case .lists: SideMenuOptionRowView(type: type)
                case .bookmarks: SideMenuOptionRowView(type: type)
                case .logout:
                    Button {
                        viewModel.singOut()
                    } label: {
                        SideMenuOptionRowView(type: type)
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(.leading, 20)
        .frame(width: UIScreen.main.bounds.width - 90, alignment: .leading)
        .background(Color.white)
    }
}

#Preview {
    SideMenuView(showSideMenu: .constant(false))
}

