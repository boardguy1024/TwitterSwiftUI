//
//  AuthViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/24.
//

import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
     
    init() {
        self.userSession = Auth.auth().currentUser
        
        print("DEBUG: User Session is: \(self.userSession)")
    }
    
    func login(withEmail email: String, password: String) {
        print("DEBUG: login with Email: \(email)")

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to login with error: \(error.localizedDescription)")
                // TODO: 必要によってエラーを表示する
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            print("DEBUG: Logged in user successfully")

        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error: \(error.localizedDescription)")
                // TODO: 必要によってエラーを表示する
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            
            print("DEBUG: Registered user successfully")
            print("DEBUG: User is \(self.userSession)")
            
            //ユーザー登録が成功した場合、紐づくデータをDataBaseにPost
            
            let userDataDic = ["email": email,
                               "username": username,
                               "fullname": fullname,
                               "uid": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(userDataDic) { _ in
                    print("DEBUG: Did upload user data")
                }
        }
    }
    
    func signOut() {
        userSession = nil
        try? Auth.auth().signOut()
     }
}

