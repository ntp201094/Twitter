//
//  Channel.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import FirebaseFirestore

class Channel {
    
    let id: String?
    let name: String
    
    init(name: String) {
        id = nil
        self.name = name
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let name = data["name"] as? String else {
            return nil
        }
        
        id = document.documentID
        self.name = name
    }
    
}

extension Channel: DataObjectSerializable {
    
    var representation: [String : Any] {
        var representation = ["name": name]
        
        if let id = id {
            representation["id"] = id
        }
        
        return representation
    }
    
}

extension Channel: Comparable {
    
    static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.name < rhs.name
    }
    
}
