//
//  MainTabView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI


struct MainTabView: View {
    
    @State private var showSideMenu: Bool = false
    @State private var selectedIndex: Int = 0
    
    @State private var offset: CGFloat = 0
    private let sideBarWidth = UIScreen.main.bounds.width - 90

    @GestureState private var gestureOffset: CGFloat = 0

    var body: some View {
        
        HStack {
            
            SideMenuView(showSideMenu: $showSideMenu)
            
            TabView(selection: $selectedIndex) {
                
                FeedView(showSideMenu: $showSideMenu)
                    .onTapGesture {
                        self.selectedIndex = 0
                    }
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                
                ExploreView()
                    .onTapGesture {
                        self.selectedIndex = 1
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(1)
                
                NotificationsView()
                    .onTapGesture {
                        self.selectedIndex = 2
                    }
                    .tabItem {
                        Image(systemName: "bell")
                    }
                    .tag(2)
                
                MessagesView()
                    .onTapGesture {
                        self.selectedIndex = 3
                    }
                    .tabItem {
                        Image(systemName: "envelope")
                    }
                    .tag(3)
            }
        }
        // サイドメニューとMainViewが同時に移動するため
        .frame(width: sideBarWidth + UIScreen.main.bounds.width)
        .offset(x: -sideBarWidth / 2) // サイドメニューを左側に隠す
        .offset(x: offset)
        .onChange(of: showSideMenu) { newValue in
            print("!!!!")
        }
        .onChange(of: gestureOffset) { newValue in
            offset = newValue
        }
        .gesture(
            DragGesture()
                .updating($gestureOffset, body: { value, out, _ in
                    out = value.translation.width
                })
        )
        
        
    }
}

#Preview {
    MainTabView()
}
