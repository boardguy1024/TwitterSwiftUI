//
//  ProfileViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var isFollowed = false
    
    let user: User
    
    var actionButtonTitle: String {
        user.isCurrentUser ? "プロフィールを編集" : isFollowed ? "フォロー中" : "フォローする"
    }
    
    init(user: User) {
        self.user = user
        
        Task {
            try await self.checkIfUserIsFollowing()
        }
    }
    
    // MARK: From View
    func actionButtonTapped() {
        
        if user.isCurrentUser {
            // Edit Profile
            
        } else {
            // Follow or Following
            Task {
                if isFollowed {
                    try await unfollow()
                } else {
                    try await follow()
                }
            }
            
        }
    }
    
    @MainActor
    private func checkIfUserIsFollowing() async throws {
        guard let uid = user.id else { return }
        self.isFollowed = try await UserService.shared.checkIfUserIsFollowing(for: uid)
    }
    
    // MARK: Privates
    
    @MainActor
    private func follow() async throws {
        guard let uid = user.id else { return }
        self.isFollowed = try await UserService.shared.followUser(uid: uid)
    }
    
    @MainActor
    func unfollow() async throws {
        guard let uid = user.id else { return }
        let unfollowed = try await UserService.shared.unfollowUser(uid: uid)
        self.isFollowed = !unfollowed
    }
}
