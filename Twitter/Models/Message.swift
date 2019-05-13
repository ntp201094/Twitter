//
//  Message.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import Firebase
import FirebaseFirestore
import MessageKit

class Message: MessageType {
    
    let id: String?
    let content: String
    let sentDate: Date
    let sender: SenderType
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var kind: MessageKind {
        return .text(content)
    }
    
    init(user: User, content: String) {
        sender = Sender(senderId: user.uid, displayName: AppSettings.displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = data["created"] as? Date else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(senderId: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
        } else {
            return nil
        }
    }
}

extension Message: DataObjectSerializable {
    var representation: [String : Any] {
        return [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
    }
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
