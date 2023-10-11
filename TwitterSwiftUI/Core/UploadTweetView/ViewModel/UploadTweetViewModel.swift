//
//  UploadTweetViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import SwiftUI

class UploadTweetViewModel: ObservableObject {
    
    @Published var didUploadTweet = false
        
    @MainActor
    func uploadTweet(withCaption caption: String) async throws {
        let success = try await TweetService.shared.uploadTweet(caption: caption)
        if success { didUploadTweet = true }
    }
}
