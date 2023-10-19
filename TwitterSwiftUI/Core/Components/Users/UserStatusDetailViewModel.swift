//
//  UserStatusDetailViewModel.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/19.
//

import Foundation

enum FollowStatusType: Int, CaseIterable, Identifiable {
    case followers
    case following
    
    var title: String {
        switch self {
        case .followers: "フォロワー"
        case .following: "フォロー中"
        }
    }
    
    var id: Int { self.rawValue }
}

class UserStatusDetailViewModel: ObservableObject {
    
    let user: User
    
    @Published var followers = [User]()
    @Published var following = [User]()
    
    @Published var selectedTab: Int = FollowStatusType.followers.rawValue
    
    init(user: User) {
        self.user = user
    }
    
    func fetchFollowers() {
        
        
    }
}
