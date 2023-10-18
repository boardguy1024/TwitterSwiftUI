//
//  UserStatusDetailView.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/17.
//

import SwiftUI

struct UserStatusDetailView: View {
    
    @EnvironmentObject var tabBarViewModel: MainTabBarViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("UserStatusDetailView")
        }
        .onAppear {
            tabBarViewModel.showUserStatusDetail = false
        }
    }
    
}

#Preview {
    UserStatusDetailView()
}
