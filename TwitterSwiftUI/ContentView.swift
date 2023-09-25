//
//  ContentView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI
import Kingfisher

struct ContentView: View {

    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showMenu = false

    var body: some View {
    
        Group {
            
            // no user logged in
            if authViewModel.userSession == nil {
                LoginView()
            } else {
                mainTabView
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    var mainTabView: some View {
        ZStack(alignment: .topLeading) {
            MainTabView()
                .navigationBarHidden(showMenu)
            
            Color(.black)
                .opacity(showMenu ? 0.2 : 0)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        showMenu.toggle()
                    }
                }
                .ignoresSafeArea()
            
            SideMenuView()
                .frame(width: 300)
                .background(Color.white)
                .offset(x: showMenu ? 0 : -300)

        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    withAnimation(.easeInOut) {
                        showMenu.toggle()
                    }
                } label: {
                    if let user = authViewModel.currentUser {
                        KFImage(URL(string: user.profileImageUrl))
                            .resizable()
                            .placeholder({ _ in
                                Circle() // TODO: Default画像にすべき
                            })
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .onAppear {
            // SideMenuから画面遷移して戻った際にはSideMenuを閉じる
            showMenu = false
        }
    }
}
