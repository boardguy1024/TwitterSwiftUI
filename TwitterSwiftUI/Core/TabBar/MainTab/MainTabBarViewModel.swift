//
//  MainTabBarViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/08.
//

import Foundation

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
}
