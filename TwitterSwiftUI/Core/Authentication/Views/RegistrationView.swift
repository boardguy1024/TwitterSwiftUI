//
//  RegistrationView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // 画面を遷移させるため使用
        NavigationStack {

            VStack {
                AuthHeaderView(title1: "Get Started.", title2: "Create your account.")
                
                VStack(spacing: 40) {
                    CustomTextField(imageName: "envelope", placeholdeer: "Email", text: $email)
                    CustomTextField(imageName: "person", placeholdeer: "User name", text: $username)
                    CustomTextField(imageName: "person", placeholdeer: "Full name", text: $fullname)
                    CustomTextField(imageName: "lock",
                                    placeholdeer: "Password",
                                    isSecureField: true,
                                    text: $password)
                }
                .padding(32)
                
                AuthSubmitButton(title: "Sign Up", width: 340) {
                    viewModel.register(withEmail: email,
                                       password: password,
                                       fullname: fullname,
                                       username: username)
                }
                
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarHidden(true)
                } label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.footnote)
                        
                        Text("Sign In")
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                }
                .foregroundColor(Color(.systemBlue))
                .padding(.bottom, 32)
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $viewModel.didAuthenticateUser) {
                // ユーザー登録が完了したらプロフィール画像選択画面へ遷移
                ProfilePhotoSelectView()
            }
        }
    }
}

#Preview {
    RegistrationView()
}
