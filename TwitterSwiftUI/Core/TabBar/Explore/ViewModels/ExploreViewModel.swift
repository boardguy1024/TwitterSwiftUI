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
        Task { try await self.fetchUsers() }
    }
    
    @MainActor
    func fetchUsers() async throws {
        self.users = try await UserService.shared.fetchUsers()
    }
}
