//
//  BaseNavigationController.swift
//  Twitter
//
//  Created by Phuc Nguyen on 5/13/19.
//  Copyright © 2019 Phuc Nguyen. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    init(_ rootVC: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        pushViewController(rootVC, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.tintColor = .primary
        navigationBar.prefersLargeTitles = true
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.primary]
        navigationBar.largeTitleTextAttributes = navigationBar.titleTextAttributes
        
        toolbar.tintColor = .primary
    }

}
