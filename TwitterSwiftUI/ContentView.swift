//
//  ContentView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMenu = false

    var body: some View {
    
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
                    Circle()
                        .frame(width: 32, height: 32)
                }
            }
        }
        .onAppear {
            // SideMenuから画面遷移して戻った際にはSideMenuを閉じる
            showMenu = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
