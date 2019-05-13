//
//  AppDelegate.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/11/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(authStateDidChange), name: Notification.Name.AuthStateDidChange, object: nil)
        
        show(in: UIWindow(frame: UIScreen.main.bounds))
        
        return true
    }
    
    @objc func authStateDidChange() {
        self.changeInitialScreen()
    }
    
    func changeInitialScreen() {
        if let user = Auth.auth().currentUser {
            if let channelsVC = ChannelsViewController.storyboardInstance() {
                channelsVC.currentUser = user
                window?.rootViewController = BaseNavigationController(channelsVC)
            }
        } else {
            if let loginVC = LoginViewController.storyboardInstance() {
                window?.rootViewController = loginVC
            }
        }
    }
    
    func show(in window: UIWindow?) {
        guard let window = window else {
            fatalError("Cannot layout app with a nil window.")
        }
        
        FirebaseApp.configure()
        
        self.window = window
        window.tintColor = .primary
        window.backgroundColor = .white
        
        authStateDidChange()
        
        window.makeKeyAndVisible()
    }


}

