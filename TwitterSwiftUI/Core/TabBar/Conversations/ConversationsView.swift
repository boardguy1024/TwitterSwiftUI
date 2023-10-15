//
//  ConversationsView.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/14.
//

import SwiftUI

struct ConversationsView: View {
    
    @Binding var showSideMenu: Bool
    @StateObject var viewModel: ConversationsViewModel
    
    init(showSideMenu: Binding<Bool>) {
        _showSideMenu = showSideMenu
        _viewModel = .init(wrappedValue: ConversationsViewModel())
    }

    var body: some View {
        
        NavigationStack {
            
            NavigationHeaderView(showSideMenu: $showSideMenu, user: $viewModel.currentUser, headerTitle: "メッセージ")
        
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    if viewModel.recentMessages.isEmpty && !viewModel.showLoading {
                        emptyView
                    } else {
                        LazyVStack {
                            ForEach(viewModel.recentMessages) { message in
                                
                                NavigationLink {
                                    ChatView(user: message.user)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    ConversationRowView(message: message)
                                }
                            }
                        }
                    }
                    
                    if viewModel.showLoading { ProgressView() }
                }
            }
            
        }
    }
}

extension ConversationsView {
    
    var emptyView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("受信トレイへようこそ")
                .font(.title)
                .fontWeight(.heavy)
            
            Text("Drop a line, share posts and more with private conversations between you and others on X.")
                .foregroundStyle(.secondary)
            
            Button {
                
            } label: {
                Button {
                    
                } label: {
                    Text("メッセージを書く")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                        )
                }
            }
            .padding(.top, 20)

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 30)
        
        
    }
}

#Preview {
    ConversationsView(showSideMenu: .constant(false))
}
