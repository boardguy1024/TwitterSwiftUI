//
//  ProfileEditViewModel.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/20.
//

import Foundation
import Combine

class ProfileEditViewModel: ObservableObject {
    
    let user: User
    
    @Published var name: String = ""
    @Published var bio: String = ""
    @Published var location: String = ""
    @Published var webUrl: String = ""
    
    @Published var saveButtonDisable: Bool = true
    
    private var cancellable = Set<AnyCancellable>()
    
    init(user: User) {
        self.user = user
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        
        Publishers.CombineLatest4($name, $bio, $location, $webUrl)
            .map { name, bio, location, webUrl in
                return name.isEmpty && bio.isEmpty && location.isEmpty && webUrl.isEmpty
            }
            .assign(to: \.saveButtonDisable, on: self)
            .store(in: &cancellable)
    }
}
