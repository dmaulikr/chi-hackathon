//
//  GameViewController.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var authLabel: UILabel!
    
    let gcManager = GameCenterManager.sharedInstance
    let audioManager = AudioManager.sharedInstance
    let leaderboardID = ""
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gcManager.gameVC = self
        addObservers()
    }
    
    deinit {
        removeObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(authSuccess), name: NSNotification.Name(GameCenterManager.Authenticated), object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Notification Handlers
    func authSuccess() {
        UIView.animate(withDuration: 0.25, animations: {
            self.activityIndicator.alpha = 0
            self.authLabel.alpha = 0
        }, completion: { finished in
            //        
        })
    }
    
    // MARK: Start Game
    func presentGameScene() {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            
            if let view = self.view as! SKView? {
                view.showsFPS = true
                view.showsNodeCount = true
                view.ignoresSiblingOrder = true
                
                view.presentScene(scene)
            }
        }
    }

}
