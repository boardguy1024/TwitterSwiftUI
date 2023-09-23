//
//  LoginView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            
            // HeaderView
            VStack(alignment: .leading) {
                // frame.maxWidthを使うと要素が真ん中表示だが、
                // Hstackを使うことで画面いっぱいで左寄せになる
                HStack { Spacer() }
                
                Text("Hello.")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
            }
            .frame(height: 260)
            .padding(.leading)
            .background(Color(.systemBlue))
            .foregroundColor(.white)
            
            Spacer()
        }
        .ignoresSafeArea()


    }
}

#Preview {
    LoginView()
}
 
