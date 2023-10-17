//
//  MainTabBarViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/08.
//


import SwiftUI

enum MainTabBarFilter: Int, CaseIterable, Identifiable {
    case home
    case explore
    case notifications
    case messages
 
    var image: String {
        switch self {
        case .home: "Home"
        case .explore: "Search"
        case .notifications: "Notifications"
        case .messages: "Message"
        }
    }
    
    var id: Int { self.rawValue }
}

class MainTabBarViewModel: ObservableObject {
    @Published var showSideMenu: Bool = false
    @Published var hiddenNewTweetButton: Bool = false
    @Published var showNewMessageView: Bool = false
    @Published var showNewTweetView: Bool = false
    @Published var selectedTab: MainTabBarFilter = .home

    func updateNewTweetButton(isHidden: Bool) {
        withAnimation {
            hiddenNewTweetButton = isHidden
        }
    }
    
    func newTweetButtonTapped(tap: MainTabBarFilter) {
        switch tap {
        case .messages:
            showNewMessageView = true
        case .home, .explore:
            showNewTweetView = true
        case .notifications:
            break
        }
    }
}
