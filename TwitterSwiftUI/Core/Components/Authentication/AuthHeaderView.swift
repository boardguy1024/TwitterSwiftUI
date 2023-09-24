//
//  AuthHeaderView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import SwiftUI

struct AuthHeaderView: View {
    
    let title1: String
    let title2: String
    
    var body: some View {
        
        // HeaderView
        VStack(alignment: .leading) {
            // frame.maxWidthを使うと要素が真ん中表示だが、
            // Hstackを使うことで画面いっぱいで左寄せになる
            HStack { Spacer() }
            
            Text(title1)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(title2)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
        }
        .frame(height: 260)
        .padding(.leading)
        .background(Color(.systemBlue))
        .foregroundColor(.white)
        .clipShape(RoundedShape(corners: [.bottomRight], cornerRadius: 80))
    }
}

#Preview {
    AuthHeaderView(title1: "Hello", title2: "Welcome Back")
}
