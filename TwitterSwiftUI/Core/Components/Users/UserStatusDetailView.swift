//
//  UserStatusDetailView.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/17.
//

import SwiftUI

struct UserStatusDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var tabBarViewModel: MainTabBarViewModel
    @StateObject var viewModel: UserStatusDetailViewModel
    
    init(user: User) {
        _viewModel = .init(wrappedValue: UserStatusDetailViewModel(user: user))
    }
    var body: some View {
        VStack(spacing: 0) {
            PagerTabView(selected: $viewModel.selectedTab, tabs:
                            [
                                TabLabel(type: .followers),
                                TabLabel(type: .following)
                            ]) {
                                ForEach(FollowStatusType.allCases) { type in
                                    FeedTabListView()
                                        .environmentObject(self.viewModel)
                                        .frame(width: UIScreen.main.bounds.width)
                                }
                            }
        }
        .overlay(navigationHeader.edgesIgnoringSafeArea(.top), alignment: .top)
        .onAppear {
            tabBarViewModel.showUserStatusDetail = false
        }
    }
    
    @ViewBuilder
    func TabLabel(type: FollowStatusType) -> some View {
        Text(type.title)
            .font(.subheadline)
            .fontWeight(.bold)
            .padding(.horizontal, 40)
            .padding(.top, 3)
            .padding(.bottom, 6)
            .background(Color.white)
    }
}

extension UserStatusDetailView {
    var navigationHeader: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                HStack {
                    Image(systemName:"chevron.left")
                    Text(viewModel.user.username)
                        .bold()
                }
            }
            .font(.subheadline)
            .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.top, 60)
        .padding([.leading, .bottom])
        .background(BlurView().ignoresSafeArea())
    }
}

#Preview {
    UserStatusDetailView(user: PreviewProvider.shared.user)
}
