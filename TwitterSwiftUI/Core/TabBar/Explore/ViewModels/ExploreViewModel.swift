//
//  ExploreViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import SwiftUI

class ExploreViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var searchText = ""
    
    let service = UserService()
    
    var searchableUsers: [User] {
        if searchText.isEmpty {
            return self.users
        } else {
            let lowercasedQuery = searchText.lowercased()
            
            let searchedUsers = self.users.filter({
                $0.fullname.lowercased().contains(lowercasedQuery) ||
                $0.username.lowercased().contains(lowercasedQuery)
            })
            return searchedUsers
        }
    }
    
    init() {
        self.fetchUsers()
    }
    
    func fetchUsers() {
        
        service.fetchUsers { users in
            self.users = users
        }
    }
}
