//
//  GameNavigationController.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import UIKit

class GameNavigationController: UINavigationController {
    
    let gcManager = GameCenterManager.sharedInstance

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        gcManager.authenticateLocalPlayer()
        
    }
    
    deinit {
        removeObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showAuthenticationViewController), name: NSNotification.Name(GameCenterManager.PresentAuthenticationViewController), object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Notification Handlers
    func showAuthenticationViewController() {
        print(viewControllers)
        
        if gcManager.authVC != nil && topViewController != nil {
            topViewController!.present(gcManager.authVC!, animated: true, completion: nil)
        }
    }
    
}
