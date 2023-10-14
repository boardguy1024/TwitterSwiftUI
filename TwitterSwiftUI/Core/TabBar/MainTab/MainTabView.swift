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
    
    init() {
        // カスタムTabBarを使うため、default tabBarを隠す
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            SideMenuView(showSideMenu: $showSideMenu)
            
            ZStack(alignment: .bottomTrailing) {
                
                VStack(spacing: 0) {
                    TabView(selection: $selectedIndex) {
                        
                        FeedView(showSideMenu: $showSideMenu)
                            .tag(0)
                        
                        ExploreView()
                            .tag(1)
                        
                        NotificationsView()
                            .tag(2)
                        
                        ConversationsView()
                            .tag(3)
                    }
                    
                    VStack(spacing: 0) {
                        
                        Divider()
                        
                        // CustomTabBar
                        HStack(spacing: 0) {
                            TabButton(image: "Home", tag: 0)
                            
                            TabButton(image: "Search", tag: 1)
                            
                            TabButton(image: "Notifications", tag: 2)
                            
                            TabButton(image: "Message", tag: 3)
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        .background(Color.black.opacity(0.03)) // 確認のため背景をかける
                    }
                }
                .overlay(
                    Color.black  //   ( 1 or 0 ) / 5 =  1の場合 opacityは 0.2
                        .opacity( (offset / sideBarWidth) / 5.0 )
                        .ignoresSafeArea()
                        .onTapGesture {
                            showSideMenu = false
                        }
                )
                
                Button {
                    // showNewTweetView.toggle()
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .background(
                    Circle()
                        .fill(Color(.systemBlue))
                        .frame(width: 54, height: 54)
                )
                .padding(.trailing, 36)
                .padding(.bottom, 70)
            }
            
        }
        .animation(.easeInOut(duration: 0.2), value: offset == 0)
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
                            
                            // 指を離した位置が sideBarWidthの半分を超えた場合
                            // (注意: valueは draggingにより 0から始まる
                            if value.translation.width > sideBarWidth / 2 {
                                
                                offset = sideBarWidth
                                lastStoredOffset = sideBarWidth
                                showSideMenu = true
                            } else {
                                // sideMenuが開いている状態で右端の方にdraggingした際には誤って閉じないように回避させる
                                if value.translation.width > sideBarWidth && showSideMenu {
                                    offset = 0
                                    showSideMenu = false
                                } else {
                                    // velocityによる判定
                                    // 指を離した位置が半分以下でも Dragging加速度が早ければ SideMenuを開く
                                    if value.velocity.width > 800 {
                                        offset = sideBarWidth
                                        showSideMenu = true
                                    } else if showSideMenu == false {
                                        // showSideMenu == false状態で、指を離した位置が半分以下なら 元に戻す
                                        offset = 0
                                        showSideMenu = false
                                    }
                                }
                            }
                        } else {
                            // <<<Dragging
                            
                            if -value.translation.width > sideBarWidth / 2 {
                                offset = 0
                                showSideMenu = false
                            } else {
                                
                                // sideMenuが閉じている状態で左の方にDraggingする場合には
                                // この処理を回避させる
                                guard showSideMenu else {
                                    return }
                                
                                // 指を離した位置が半分以下でも <<<左のDragging加速度が早ければ sideMenuを閉じる
                                if -value.velocity.width > 800 {
                                    offset = 0
                                    showSideMenu = false
                                } else {
                                    offset = sideBarWidth
                                    showSideMenu = true
                                }
                            }
                        }
                    }
                    
                    lastStoredOffset = offset
                })
        )
    }
    
    @ViewBuilder
    func TabButton(image: String, tag: Int) -> some View {
        Button {
            withAnimation {
                selectedIndex = tag
            }
        } label: {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 23, height: 23)
                .foregroundColor(selectedIndex == tag ? .primary : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}
