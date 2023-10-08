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
    
    private let sideBarWidth = UIScreen.main.bounds.width - 90

    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0

    var body: some View {
        
        HStack(spacing: 0) {
            
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
            .overlay(
                Color.black  //   ( 1 or 0 ) / 5 =  1の場合 opacityは 0.2
                    .opacity( (offset / sideBarWidth) / 5.0 )
                    .ignoresSafeArea()
            )
        }
        .animation(.linear(duration: 0.15), value: offset == 0)
        // サイドメニューとMainViewが同時に移動するため
        .frame(width: sideBarWidth + UIScreen.main.bounds.width)
        .offset(x: -sideBarWidth / 2) // サイドメニューを左側に隠す
        .offset(x: offset)
        .onChange(of: showSideMenu) { newValue in
            
            if showSideMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = sideBarWidth
            }
            
            if !showSideMenu && offset == sideBarWidth {
                offset = 0
                lastStoredOffset = 0
            }
  
        }
        .onChange(of: gestureOffset) { _ in
            
            if gestureOffset != 0 {
                                
                // Draggingしたwidthが SideBarWidth以内の場合
                if gestureOffset + lastStoredOffset < sideBarWidth && (gestureOffset + lastStoredOffset) > 0 {
                    
                    offset = lastStoredOffset + gestureOffset
                    
                } else {
                    // sideMenuWidth範囲外の場合
                    if gestureOffset + lastStoredOffset < 0 {
                        // Draggingがdeviceの左端を超えた場合には 0で sideMenuを完全にしまう
                        offset = 0
                    }
                }
            }
        }
        .gesture(
            DragGesture()
                .updating($gestureOffset, body: { value, out, _ in
                    out = value.translation.width
                })
                .onEnded({ value in

                    withAnimation(.spring(duration: 0.15)) {
                        if value.translation.width > 0 {
                            // Dragging>>>
                            
                            if value.translation.width > sideBarWidth / 2 {
                                offset = sideBarWidth
                                lastStoredOffset = sideBarWidth
                                showSideMenu = true
                            } else {
                                
                                // sideMenuが開いている状態で右端の方にdraggingした際には誤って閉じないように回避させる
                                guard value.translation.width > sideBarWidth else { return }
                                offset = 0
                                showSideMenu = false
                            }
                        } else {
                            // <<<Dragging
                            if -value.translation.width > sideBarWidth / 2 {
                                                   
                                offset = 0
                                lastStoredOffset = 0
                                showSideMenu = false
                            } else {
                                // sideMenuが閉じている状態で左の方にDraggingする場合には
                                // この処理を回避させる
                                guard showSideMenu else { return }
                                offset = sideBarWidth
                                showSideMenu = true
                            }
                        }
                    }
                   
                    lastStoredOffset = offset
                })
        )
    }
}

#Preview {
    MainTabView()
}
