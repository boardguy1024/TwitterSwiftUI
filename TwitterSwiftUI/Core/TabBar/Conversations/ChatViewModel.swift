//
//  ChatViewModel.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/14.
//

import SwiftUI
import Firebase

struct ChatViewModel {
    let user: User
        
    init(user: User) {
        self.user = user
    }
    
    func sendButtonTapped(with message: String, completion: @escaping () -> Void) async throws {
        do {
            try await sendMessage(message, to: user)
            completion()
        } catch {
            print("Failed sendMessage: \(error.localizedDescription)")
        }
    }
    
    private func fetchMessages() {
        
    }
    
    @MainActor
    private func sendMessage(_ messageText: String, to user: User) async throws {
        guard let currentUid = AuthService.shared.userSession?.uid, let userId = user.id else { return }
        let messageRef = Firestore.firestore().collection("messages")
        
        // 自分Ref
        let currentUserRef = messageRef.document(currentUid).collection(userId).document()
        let currentRecnetRef = messageRef.document(currentUid).collection("recent-messages")
        // 相手Ref
        let receivingUserRef = messageRef.document(userId).collection(currentUid)
        let receivingRecentRef = messageRef.document(userId).collection("recent-messages")
        
        let messageId = currentUserRef.documentID
        
        let data: [String: Any] = ["text": messageText,
                                   "id": messageId,
                                   "fromId": currentUid,
                                   "toId": userId, "timestamp": Timestamp(date: Date())]
        
        try await currentUserRef.setData(data)
        try await receivingUserRef.document(messageId).setData(data)
        
        // recent-messages
        try await currentRecnetRef.document(userId).setData(data)
        try await receivingRecentRef.document(currentUid).setData(data)
    }
}
 
