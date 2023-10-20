//
//  ProfileEditViewModel.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/20.
//

import Foundation

class ProfileEditViewModel: ObservableObject {
    
    let user: User
    
    init(user: User) {
        self.user = user
    }
}
