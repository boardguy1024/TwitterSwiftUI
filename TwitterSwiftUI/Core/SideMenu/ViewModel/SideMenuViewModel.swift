//
//  SideMenuViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/23.
//

import FirebaseAuth
import Combine

enum SideMenuListType: Int, CaseIterable {
    case profile
    case lists
    case bookmarks
    case logout
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .lists: return "Lists"
        case .bookmarks: return "Bookmarks"
        case .logout: return "Logout"
        }
    }
    
    var imageName: String {
        switch self {
        case .profile: return "person"
        case .lists: return "list.bullet"
        case .bookmarks: return "bookmark"
        case .logout: return "arrow.left.square"
        }
    }  
    
    var id: Int { self.rawValue }
}

class SideMenuViewModel: ObservableObject {

    @Published var user: User?
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        setupSubscribers()
    }
    
    func singOut() {
        AuthService.shared.signOut()
    }
    
    private func setupSubscribers() {
        AuthService.shared.$currentUser.sink { [weak self] user in
            self?.user = user
        }
        .store(in: &cancellable)
    }
}
