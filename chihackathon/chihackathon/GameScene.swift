//
//  GameScene.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let gcManager = GameCenterManager.sharedInstance
    let audioManager = AudioManager.sharedInstance

    var lastUpdateTime: TimeInterval = 0
    var runner1 = Runner(texture: SKTexture(), color: SKColor.red, size: CGSize(width: 40, height: 40), name: "runner1", number: 1)
    var runner2 = Runner(texture: SKTexture(), color: SKColor.blue, size: CGSize(width: 40, height: 40), name: "runner2", number: 2)
    var runners: [Runner]?
    
    let soundCoin = SKAction.playSoundFileNamed("CoinPickup.mp3",
                                                waitForCompletion: false)
    
    // MARK: Init
    override func didMove(to view: SKView) {
        lastUpdateTime = 0
        audioManager.playBackgroundMusic(filename: "Dreamcatcher")
        
        setupRunners()
    }
    
    private func onCoinPickup(runner: Runner){
        runner.pickUpCoin()
        run(soundCoin)
    }
    
    private func setupRunners() {
        runners = [runner1, runner2]
        
        for runner in runners! {
            runner.physicsBody = SKPhysicsBody(rectangleOf: runner.size)
            
            if runner == runner1 {
                runner.position = CGPoint(x: 150, y: 200)
            }
            else {
                runner.position = CGPoint(x: 100, y: 200)
            }
            
            addChild(runner)
        }
    }
    
    // MARK: Update Loop
    override func update(_ currentTime: TimeInterval) {
        let dt = calculateDT(currentTime: currentTime)
        
        updateRunnerPositions(dt: dt)
    }
    
    private func calculateDT(currentTime: TimeInterval) -> TimeInterval {
        if lastUpdateTime == 0 {
            lastUpdateTime = currentTime
        }
        
        let dt = currentTime - lastUpdateTime
        
        lastUpdateTime = currentTime
        
        return dt
    }
    
    private func updateRunnerPositions(dt: TimeInterval) {
        for runner in runners! {
            runner.position.x += 5
        }
    }
    
    // MARK: Input
    var force: CGFloat = 0.0
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        force = 0

        let timerAction = SKAction.wait(forDuration: 1.0)
        let update = SKAction.run {
            if self.force < 100.0 {
                self.force += 1.0
            }
        }
        let sequence = SKAction.sequence([timerAction, update])
        let calculateJumpForce = SKAction.repeatForever(sequence)
        
        run(calculateJumpForce, withKey:"calculateJumpForce")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAction(forKey: "repeatAction")
        runner1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: force))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}
