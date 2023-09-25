//
//  UploadTweetViewModel.swift
//  TwitterSwiftUI
//
//  Created by パクギョンソク on 2023/09/25.
//

import SwiftUI

class UploadTweetViewModel: ObservableObject {
    
    @Published var didUploadTweet = false
    
    let service = TweetService()
    
    func uploadTweet(withCaption caption: String) {
        service.uploadTweet(caption: caption) { [weak self] success in
            if success {
                self?.didUploadTweet = true
            } else {
                // show error message to user.
            }
        }
    }
    
    
}
