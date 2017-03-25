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
    @IBOutlet weak var timeLabel: UILabel!
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
    
    var timer = Timer()
    var totalTimeElapsed: TimeInterval = 0
    
    var gameScene: GameScene?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.alpha = 0
        builderView.alpha = 0
        
        gcManager.gameVC = self
        addObservers()
    }
    
    deinit {
        timer.invalidate()
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
            
            self.timeLabel.alpha = 1
            self.builderView.alpha = 1
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
                
                gameScene = scene as? GameScene
                startTimer()
            }
        }
    }
    
    // MARK: UI
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        totalTimeElapsed += timer.timeInterval
        timeLabel.text = String(totalTimeElapsed)
    }
    

    @IBAction func didTapDropSpeedBoostButton(_ sender: Any) {
        gameScene?.applySpeedBoost()
    }
    
    @IBAction func didTapDropJumpBoostButton(_ sender: Any) {
        gameScene?.applyJumpBoost()
    }

    @IBAction func didTapDropTrapButton(_ sender: Any) {
    }
    
    @IBAction func didTapDropMissileButton(_ sender: Any) {
    }
    
    
}
