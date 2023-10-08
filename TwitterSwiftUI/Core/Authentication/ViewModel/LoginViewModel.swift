//
//  LoginViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/08.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var username = ""
    @Published var fullname = ""
    @Published var password = ""
    
    @Published var didAuthenticateUser = false
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        setupSubcribers()
    }

    func login(withEmail email: String, password: String) {
        AuthService.shared.login(withEmail: email, password: password)
    }
    
    private func setupSubcribers() {
        AuthService.shared.$didAuthenticateUser.sink { [weak self] didAuthenticateUser in
            self?.didAuthenticateUser = didAuthenticateUser
        }
        .store(in: &cancellable)
    }
}
