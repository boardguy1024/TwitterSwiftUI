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
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var uploadViewModel = UploadTweetViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // TODO: caption.isEmpTy == falseの場合にはアラートを出す
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundStyle(Color(.systemBlue))
                }
                
                Spacer()
                
                Button {
                    uploadViewModel.uploadTweet(withCaption: self.caption)
                } label: {
                    Text("Tweet")
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
                if let user = authViewModel.currentUser {
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                }
                
                TextAreaView("What's happening?", text: $caption)
            }
            .padding()
        }
        .onReceive(uploadViewModel.$didUploadTweet, perform: { success in
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                // show error
            }
        })
    }
}

#Preview {
    NewTweetView()
}
