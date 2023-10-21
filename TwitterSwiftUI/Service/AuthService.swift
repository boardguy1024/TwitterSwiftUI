//
//  AuthService.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/10/8.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthService: ObservableObject {
    
    static let shared = AuthService()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser: Bool = false
    
    // createUser -> uploadedProfileImage -> updateUserWithProfileImageUrlまではこちらを使い、
    // このプロセスが完了したら、↑ userSessionにvalueをセットしてMainTabViewを表示するようにする
    private var tempUserSession: FirebaseAuth.User?
    
    // User
    @Published var currentUser: User?
    
    private init() {
        self.userSession = Auth.auth().currentUser
        Task { try await self.fetchUserProfile() }
    }
    
    func login(withEmail email: String, password: String) async throws  {
        print("DEBUG: login with Email: \(email)")

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user

            try await self.fetchUserProfile()

        } catch {
            print("DEBUG: Failed to login with error: \(error.localizedDescription)")
        }
    }
    
    func register(withEmail email: String, password: String, username: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register with error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.tempUserSession = user
            //self.userSession = user
            
            //ユーザー登録が成功した場合、紐づくデータをDataBaseにPost
            let userDataDic = ["email": email,
                               // 検索でユーザーを小文字でヒットさせるための工夫
                               "username_lowercase": username.lowercased(),
                               "emailUsername_lowercase": email.emailUsername?.lowercased() ?? "",
                               "username": username,
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
        
        ImageUploader.uploadProfileImage(image: image) { imageUrl in
            
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": imageUrl]) { _ in
                    // 選択したプロフィール画像が正常にStorageにアップデートし、そのdownloadUrlを取得したら
                    // userのnodeに「profileImageUrl」fieldを追加してアップデートを行う
                    // 全てが完了したら、userSessionに値をセットし、Home画面が表示されるようにする
                    self.userSession = self.tempUserSession
                }
        }
    }
    
    func refreshCurrentUser() async throws {
        try await fetchUserProfile()
    }
    
    @MainActor
    private func fetchUserProfile() async throws {
        guard let uid = userSession?.uid else { return }
        self.currentUser = try await UserService.shared.fetchUser(withUid: uid)
    }
}

