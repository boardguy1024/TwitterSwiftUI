//
//  ConversationsView.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/14.
//

import SwiftUI

struct ConversationsView: View {
    
    @StateObject var viewModel: ConversationsViewModel
    
    init() {
        _viewModel = .init(wrappedValue: ConversationsViewModel())
    }

    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
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
            .navigationTitle("チャット")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ConversationsView()
}
