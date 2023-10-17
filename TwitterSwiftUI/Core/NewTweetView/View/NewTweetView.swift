//
//  NewTweetView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI
import Kingfisher

struct NewTweetView: View {
    
    @State private var caption = ""
    @Environment(\.dismiss) var dismiss
    @StateObject var uploadViewModel = NewTweetViewModel()

    var body: some View {
        VStack {
            HStack {
                Button {
                    // TODO: caption.isEmpTy == falseの場合にはアラートを出す
                    dismiss()
                } label: {
                    Text("キャンセル")
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Button {
                    Task { try await uploadViewModel.uploadTweet(withCaption: self.caption) }
                } label: {
                    Text("ポストする")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(Color.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color(.systemBlue))
                        .clipShape(Capsule())
                }
            } 
            .padding()
            
            HStack(alignment: .top) {
                if let user = AuthService.shared.currentUser {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
                
                TextAreaView("いまどうしている？", text: $caption)
                    .offset(y: -8)
                
            }
            .padding()
        }
        .onReceive(uploadViewModel.$didUploadTweet, perform: { success in
            if success {
                dismiss()
            } else {
                // show error
            }
        })
    }
}

#Preview {
    NewTweetView()
}
