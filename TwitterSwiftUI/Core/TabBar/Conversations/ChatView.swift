//
//  ChatView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI

struct ChatView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let viewModel: ChatViewModel
    
    @State var message: String = ""
    
    init(user: User) {
        viewModel = ChatViewModel(user: user)
    }       
    
    var body: some View {
     
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                TextField("メッセージを書く", text: $message, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(minHeight: 30)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.gray.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(Color.gray.opacity(0.1), lineWidth: 1)
                    )
                Button {
                    Task {
                        try await viewModel.sendButtonTapped(with: message) {
                            self.message = ""
                        }
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                        )
                        .padding(.bottom, 3)
                }
                .disabled(message.isEmpty)
            }
            .background()
            .padding()
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
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
            }
        })
    }
}

#Preview {
    ChatView(user: PreviewProvider.shared.user)
}
