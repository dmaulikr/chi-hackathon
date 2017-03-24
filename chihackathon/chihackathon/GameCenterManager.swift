//
//  GameCenterManager.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import UIKit
import GameKit

class GameCenterManager: NSObject {
    
    static let sharedInstance = GameCenterManager()
    static let PresentAuthenticationViewController = "PresentAuthenticationViewController"
    static let Authenticated = "Authenticated"
    
    var enabled = false
    var authVC: UIViewController?
    
    // MARK: Auth
    func authenticateLocalPlayer() {
        GKLocalPlayer.localPlayer().authenticateHandler = { (viewController, error) in
            self.enabled = false
            
            if error != nil {
                let alertVC = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)

                if let navVC = UIApplication.shared.windows[0].rootViewController as? UINavigationController {
                    navVC.present(alertVC, animated: true, completion: nil)
                }
            }
            else if viewController != nil {
                self.authVC = viewController
                NotificationCenter.default.post(name: NSNotification.Name(GameCenterManager.PresentAuthenticationViewController), object: self)
            }
            else if GKLocalPlayer.localPlayer().isAuthenticated {
                self.enabled = true
                NotificationCenter.default.post(name: NSNotification.Name(GameCenterManager.Authenticated), object: self)
            }
        }
    }
    
}
