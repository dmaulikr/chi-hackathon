//
//  GameScene.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit

class GameScene: SKScene {
    
    let gcManager = GameCenterManager.sharedInstance
    let audioManager = AudioManager.sharedInstance
    let runnerCamera = SKCameraNode()

    var lastUpdateTime: TimeInterval = 0
    var runner1 = Runner(texture: SKTexture(imageNamed: "Runner"), color: SKColor.red, size: CGSize(width: 80, height: 80), name: "runner1", number: 1, team: Team())
    var runner2 = Runner(texture: SKTexture(imageNamed: "Runner"), color: SKColor.red, size: CGSize(width: 80, height: 80), name: "runner1", number: 1, team: Team())
    var runners: [Runner]?
    
    var player: Runner?

    let soundCoin = SKAction.playSoundFileNamed("CoinPickup.mp3", waitForCompletion: false)
    
    // MARK: Init
    override func didMove(to view: SKView) {
        gcManager.gameScene = self
        audioManager.playBackgroundMusic(filename: "Dreamcatcher")
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        camera = runnerCamera
        lastUpdateTime = 0

        setupRunners()
        assignPlayer()
    }
    
    private func onCoinPickup(runner: Runner){
        runner.pickUpCoin()
        run(soundCoin)
    }
    
    private func setupRunners() {
        runners = [runner1, runner2]
        
        for runner in runners! {
            runner.physicsBody = SKPhysicsBody(rectangleOf: runner.size)
            runner.physicsBody?.affectedByGravity = true
            runner.physicsBody?.allowsRotation = false
            
            if runner == runner1 {
                runner.position = CGPoint(x: 100, y: 200)
            }
            else {
                runner.position = CGPoint(x: 0, y: 200)
                runner.addChild(SKShapeNode(circleOfRadius: 50))
            }
            
            addChild(runner)
        }
    }
    
    private func assignPlayer() {
        var index = 0
        for player in gcManager.playerAssignments {
            if GKLocalPlayer.localPlayer().playerID == player {
                break
            }
            
            index += 1
        }
        
        if index == 0 {
            player = runner1
        }
        else if index == 1 {
            player = runner2
        }
        
        player?.addChild(runnerCamera)
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
    var initialJumpY: CGFloat?
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if initialJumpY == nil {
            initialJumpY = player!.position.y
        }
        
        if (player!.position.y - initialJumpY!) < 600 {
            player!.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
        }
        else {
            player!.physicsBody?.velocity.dy = 0.0
        }
        
        sendJump()
        
        //self.onGround = false
    }
    
    private func sendJump() {
        var message = ""
        if player == runner1 {
            message = "runner1DidJump"
        }
        else if player == runner2 {
            message = "runner2DidJump"
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        gcManager.sendDataFast(data: data)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //runner1.physicsBody?.velocity.dy = 0.0
        initialJumpY = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}
