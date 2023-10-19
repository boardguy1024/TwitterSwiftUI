//
//  ProfileViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var isFollowed = false
    @Published var followersCount: Int = 0
    @Published var follwoingCount: Int = 0
    
    let user: User
    
    var actionButtonTitle: String {
        user.isCurrentUser ? "プロフィールを編集" : isFollowed ? "フォロー中" : "フォローする"
    }
    
    init(user: User) {
        self.user = user
        
        Task {
            try await checkIfUserIsFollowing()
            try await fetchFollowingCount()
            try await fetchFollowersCount()
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
    
    @MainActor
    private func fetchFollowingCount() async throws {
        guard let userId = user.id else { return }
        follwoingCount = try await UserService.shared.fetchFollowingCount(with: userId)
    }
    
    @MainActor
    private func fetchFollowersCount() async throws {
        guard let userId = user.id else { return }
        followersCount = try await UserService.shared.fetchFollowersCount(with: userId)
    }
}
