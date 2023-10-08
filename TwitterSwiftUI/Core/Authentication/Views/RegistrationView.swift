//
//  RegistrationView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI

struct RegistrationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: RegistrationViewModel

    init() {
        _viewModel = .init(wrappedValue: RegistrationViewModel())
    }
    
    var body: some View {
        // 画面を遷移させるため使用
        NavigationStack {

            VStack {
                AuthHeaderView(title1: "Get Started.", title2: "Create your account.")
                
                VStack(spacing: 40) {
                    CustomTextField(imageName: "envelope", placeholdeer: "Email", text: $viewModel.email)
                    CustomTextField(imageName: "person", placeholdeer: "User name", text: $viewModel.username)
                    CustomTextField(imageName: "person", placeholdeer: "Full name", text: $viewModel.fullname)
                    CustomTextField(imageName: "lock",
                                    placeholdeer: "Password",
                                    isSecureField: true,
                                    text: $viewModel.password)
                }
                .padding(32)
                
                AuthSubmitButton(title: "Sign Up", width: 340) {
                    viewModel.register()
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
