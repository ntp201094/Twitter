//
//  ChannelsViewController.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

class ChannelsViewController: UIViewController {
    
    private let database = Firestore.firestore()
    
    private var channelReference: CollectionReference {
        return database.collection("channels")
    }
    
    var currentUser: User!
    
    private var channels: [Channel] = []
    private var channelListener: ListenerRegistration?
    
    deinit {
        channelListener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

// MARK: - Storyboard instance
extension ChannelsViewController {
    static func storyboardInstance() -> ChannelsViewController? {
        
        let storyboard = AppStoryboards.main.instance
        
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ChannelsViewController
        
    }
}
