//
//  ConversationsViewModel.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/14.
//

import Firebase

class ConversationsViewModel: ObservableObject {
    
    @Published var recentMessages: [Message] = []
    
    init() {
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let currentUid = AuthService.shared.userSession?.uid else { return }
        
        let recentMessagesRef = Firestore.firestore().collection("messages").document(currentUid).collection("recent-messages")
        recentMessagesRef.order(by: "timestamp", descending: true)
        
        recentMessagesRef.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges else { return }
            
            changes.forEach { change in
                let messageData = change.document.data()
                let partnerUId = change.document.documentID
                
                Firestore.firestore().collection("users").document(partnerUId).getDocument { snapshot, _ in
                    let user = User.decode(dic: snapshot?.data())
                    self.recentMessages.append(.init(user: user, dic: messageData))
                }
            }
        }
    }
}
