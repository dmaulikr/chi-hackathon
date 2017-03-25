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
    @IBOutlet weak var builderView: UIView!
    
    @IBOutlet weak var dropPlatformButton: UIButton!
    @IBOutlet weak var dropSpeedBoostButton: UIButton!
    @IBOutlet weak var dropJumpBoostButton: UIButton!
    @IBOutlet weak var cameraToggleButton: UIButton!
    @IBOutlet weak var dropWallButton: UIButton!
    @IBOutlet weak var dropTrapButton: UIButton!
    @IBOutlet weak var dropMissileButton: UIButton!
    
    let gcManager = GameCenterManager.sharedInstance
    let audioManager = AudioManager.sharedInstance
    let leaderboardID = ""
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gcManager.gameVC = self
        addObservers()
        //presentGameScene()
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
    
    @IBAction func didTapDropPlatformButton(_ sender: Any) {
    }
    
    @IBAction func didTapDropSpeedBoostButton(_ sender: Any) {
    }
    
    @IBAction func didTapDropJumpBoostButton(_ sender: Any) {
    }
    
    @IBAction func didTapToggleCameraButton(_ sender: Any) {
    }
    
    @IBAction func didTapDropWallButton(_ sender: Any) {
    }
    
    @IBAction func didTapDropTrapButton(_ sender: Any) {
    }
    
    @IBAction func didTapDropMissileButton(_ sender: Any) {
    }
    
    
}
