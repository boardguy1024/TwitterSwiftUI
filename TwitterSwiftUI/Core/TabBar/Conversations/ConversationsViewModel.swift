//
//  ConversationsViewModel.swift
//  TwitterSwiftUI
//
//  Created by paku on 2023/10/14.
//

import Firebase

class ConversationsViewModel: ObservableObject {
    
    @Published var recentMessages: [Message] = []
    
    // Recentメッセージはユーザーに対して1つのメッセージのみを保証
    private var recentMessagesDic = [String: Message]()
    
    init() {
        fetchRecentMessages()
    }
    
    func fetchRecentMessages() {
        guard let currentUid = AuthService.shared.userSession?.uid else { return }
        
        let recentMessagesRef = Firestore.firestore().collection("messages").document(currentUid).collection("recent-messages")
        recentMessagesRef.order(by: "timestamp", descending: true)
        
        recentMessagesRef.addSnapshotListener { [weak self] snapshot, error in
            guard let changes = snapshot?.documentChanges, let self = self else { return }
            
            changes.forEach { change in
                let messageData = change.document.data()
                let partnerUId = change.document.documentID
                
                // 配列に既に相手が存在する場合
                if self.recentMessagesDic.keys.contains(partnerUId), let user = self.recentMessagesDic[partnerUId]?.user {
    
                    self.recentMessagesDic[partnerUId] = .init(user: user, dic: messageData)
                    
                    //最新データがトップにくるように並べ替え
                    self.sortMessagesByLatest()

                } else {
                    
                    Firestore.firestore().collection("users").document(partnerUId).getDocument { [weak self] snapshot, _ in
                        guard let self = self else { return }
                        let user = User.decode(dic: snapshot?.data())
                        
                        self.recentMessagesDic[partnerUId] = .init(user: user, dic: messageData)
                       
                        //最新データがトップにくるように並べ替え
                        sortMessagesByLatest()
                    }
                }
            }
        }
    }
    
    private func sortMessagesByLatest() {
        let messages = Array(self.recentMessagesDic.values)
        let sorted = messages.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        self.recentMessages = sorted
    }
}
