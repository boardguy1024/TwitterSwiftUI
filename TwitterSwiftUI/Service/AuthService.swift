//
//  AuthService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/8.
//

import SwiftUI
import Firebase

class AuthService: ObservableObject {
    
    static let shared = AuthService()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser: Bool = false
    
    // createUser -> uploadedProfileImage -> updateUserWithProfileImageUrlまではこちらを使い、
    // このプロセスが完了したら、↑ userSessionにvalueをセットしてMainTabViewを表示するようにする
    private var tempUserSession: FirebaseAuth.User?
    
    // User
    @Published var currentUser: User?
    private let userService = UserService()
    
    private init() {
        self.userSession = Auth.auth().currentUser
        print("DEBUG: User Session is: \(String(describing: self.userSession))")
        
        self.fetchUserProfile()
    }
     
    func login(withEmail email: String, password: String) {
        print("DEBUG: login with Email: \(email)")

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("DEBUG: Failed to login with error: \(error.localizedDescription)")
                // TODO: 必要によってエラーを表示する
            }
            
            guard let user = result?.user else { return }
            self?.userSession = user
            print("DEBUG: Logged in user successfully")
            
            self?.fetchUserProfile()
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
            self.tempUserSession = user
            //self.userSession = user
            
            //ユーザー登録が成功した場合、紐づくデータをDataBaseにPost
            let userDataDic = ["email": email,
                               "username": username,
                               "fullname": fullname,
                               "uid": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(userDataDic) { [weak self] _ in
                    print("DEBUG: Did upload user data")
                    
                    //FireStoreにUser情報をセットできたらProfilePhotoViewに遷移させる
                    self?.didAuthenticateUser = true
                }
        }
    }
    
    func signOut() {
        userSession = nil
        currentUser = nil
        try? Auth.auth().signOut()
    }
    
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = tempUserSession?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]) { _ in
                    // 選択したプロフィール画像が正常にStorageにアップデートし、そのdownloadUrlを取得したら
                    // userのnodeに「profileImageUrl」fieldを追加してアップデートを行う
                    // 全てが完了したら、userSessionに値をセットし、Home画面が表示されるようにする
                    self.userSession = self.tempUserSession
                }
        }
    }
    
    private func fetchUserProfile() {
        guard let uid = userSession?.uid else { return }
        userService.fetchProfile(withUid: uid) { [weak self] user in
            self?.currentUser = user
        }
    }
}

