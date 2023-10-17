//
//  MainTabView.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/21.
//

import SwiftUI


struct MainTabView: View {
    
    private let sideBarWidth = UIScreen.main.bounds.width - 90
    
    @State private var offset: CGFloat = 0
    @State private var lastStoredOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    
    @EnvironmentObject var viewModel: MainTabBarViewModel
   
    init() {
        // カスタムTabBarを使うため、default tabBarを隠す
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            
            SideMenuView(showSideMenu: $viewModel.showSideMenu)
            
            ZStack(alignment: .bottomTrailing) {
                
                VStack(spacing: 0) {
                    TabView(selection: $viewModel.selectedTab) {
                        
                        FeedView(showSideMenu: $viewModel.showSideMenu)
                            .tag(MainTabBarFilter.home)
                        
                        ExploreView()
                            .tag(MainTabBarFilter.explore)
                        
                        NotificationsView()
                            .tag(MainTabBarFilter.notifications)
                        
                        ConversationsView(showSideMenu: $viewModel.showSideMenu,
                                          showNewMessageView: $viewModel.showNewMessageView)
                            .tag(MainTabBarFilter.messages)

                    }
                    
                    VStack(spacing: 0) {
                        
                        Divider()
                        
                        // CustomTabBar
                        HStack(spacing: 0) {
                            ForEach(MainTabBarFilter.allCases) { tab in
                                TabButton(tab: tab)
                            }
                        }
                        .padding(.top, 15)
                        .padding(.bottom, 10)
                        .background(Color.clear.opacity(0.03)) 
                    }
                }
                .overlay(
                    Color.black  //   ( 1 or 0 ) / 5 =  1の場合 opacityは 0.2
                        .opacity( (offset / sideBarWidth) / 5.0 )
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.showSideMenu = false
                        }
                )
                
                NewTweetButton(selectedTab: $viewModel.selectedTab) { tab in
                    if tab == .messages {
                        viewModel.showNewMessageView = true
                    }
                }
                .opacity(viewModel.hiddenNewTweetButton ? 0 : 1)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: offset == 0)
        // サイドメニューとMainViewが同時に移動するため
        .frame(width: sideBarWidth + UIScreen.main.bounds.width)
        .offset(x: -sideBarWidth / 2) // サイドメニューを左側に隠す
        .offset(x: offset)
        .onChange(of: viewModel.showSideMenu) { newValue in
            
            if viewModel.showSideMenu && offset == 0 {
                offset = sideBarWidth
                lastStoredOffset = sideBarWidth
            }
            
            if !viewModel.showSideMenu && offset == sideBarWidth {
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
                                viewModel.showSideMenu = true
                            } else {
                                // sideMenuが開いている状態で右端の方にdraggingした際には誤って閉じないように回避させる
                                if value.translation.width > sideBarWidth && viewModel.showSideMenu {
                                    offset = 0
                                    viewModel.showSideMenu = false
                                } else {
                                    // velocityによる判定
                                    // 指を離した位置が半分以下でも Dragging加速度が早ければ SideMenuを開く
                                    if value.velocity.width > 800 {
                                        offset = sideBarWidth
                                        viewModel.showSideMenu = true
                                    } else if viewModel.showSideMenu == false {
                                        // showSideMenu == false状態で、指を離した位置が半分以下なら 元に戻す
                                        offset = 0
                                        viewModel.showSideMenu = false
                                    }
                                }
                            }
                        } else {
                            // <<<Dragging
                            
                            if -value.translation.width > sideBarWidth / 2 {
                                offset = 0
                                viewModel.showSideMenu = false
                            } else {
                                
                                // sideMenuが閉じている状態で左の方にDraggingする場合には
                                // この処理を回避させる
                                guard viewModel.showSideMenu else {
                                    return }
                                
                                // 指を離した位置が半分以下でも <<<左のDragging加速度が早ければ sideMenuを閉じる
                                if -value.velocity.width > 800 {
                                    offset = 0
                                    viewModel.showSideMenu = false
                                } else {
                                    offset = sideBarWidth
                                    viewModel.showSideMenu = true
                                }
                            }
                        }
                    }
                    
                    lastStoredOffset = offset
                })
        )
    }
    
    @ViewBuilder
    func TabButton(tab: MainTabBarFilter) -> some View {
        Button {
            withAnimation {
                viewModel.selectedTab = tab
            }
        } label: {
            Image(tab.image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 23, height: 23)
                .foregroundColor(viewModel.selectedTab == tab ? .primary : .gray)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
}
