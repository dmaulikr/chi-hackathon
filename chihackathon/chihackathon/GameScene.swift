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
    let runnerCamera = SKCameraNode()

    var lastUpdateTime: TimeInterval = 0
    var touched = false
    var runner1 = Runner(texture: SKTexture(imageNamed: "Runner"), color: SKColor.red, size: CGSize(width: 80, height: 80), name: "runner1", number: 1, team: Team(id: 1))
    var runner2 = Runner(texture: SKTexture(imageNamed: "Runner"), color: SKColor.red, size: CGSize(width: 80, height: 80), name: "runner1", number: 1, team: Team(id: 2))
    var runners: [Runner]?

    //Sounds
    let soundCoin = SKAction.playSoundFileNamed("CoinPickup.mp3", waitForCompletion: true)
    let soundJump = SKAction.playSoundFileNamed("Jump.mp3", waitForCompletion: true)
    let soundPowerup = SKAction.playSoundFileNamed("Powerup.mp3", waitForCompletion: true)
    
    // MARK: Init
    override func didMove(to view: SKView) {
        //audioManager.playBackgroundMusic(filename: "Dreamcatcher")
        camera = runnerCamera
        lastUpdateTime = 0

        
        setupRunners()
    }
    
    private func onCoinPickup(runner: Runner){
        runner.pickUpCoin()
        run(soundCoin)
    }
    
    private func onSpeedBoostPickup(runner: Runner){
        runner.applySpeedBoost()
        run(soundPowerup)
    }
    
    private func onJumpBoostPickup(runner: Runner){
        runner.applyJumpBoost()
        run(soundPowerup)
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
            }
            
            addChild(runner)
        }
        
        runner1.addChild(runnerCamera)
    }
    
    // MARK: Update Loop
    override func update(_ currentTime: TimeInterval) {
        let dt = calculateDT(currentTime: currentTime)
        
        updateRunnerPositions(dt: dt)
        if runner1.physicsBody?.velocity.dy == 0 {
            ableToJump = true
        }else {
            ableToJump = false
        }
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
    var ableToJump = true
    var jumpForce = CGFloat(200.0)
    
    func jump(runner: Runner, force: CGFloat){
        if ableToJump == true {
            run(soundJump)
            runner.physicsBody?.applyImpulse(CGVector(dx: 0, dy: force))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in (touches ){
            _ = SKAction.wait(forDuration: 0.0)
            _ = SKAction.run({
                if(self.jumpForce < Constants.maxJumpForce){
                    print(self.jumpForce)
                    self.jumpForce += 100.0
                }else{
                    self.jumpForce = Constants.maxJumpForce
                    self.jump(runner: self.runner1, force: Constants.maxJumpForce)
                }
            })
        }
        
//        if initialJumpY == nil {
//            run(soundJump)
//            initialJumpY = runner1.position.y
//        }
//        
//        if (runner1.position.y - initialJumpY!) < 600 {
//            runner1.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 200))
//        }
//        else {
//            runner1.physicsBody?.velocity.dy = 0.0
//        }
//        
//        //self.onGround = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {}
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //runner1.physicsBody?.velocity.dy = 0.0
        initialJumpY = nil
        jump(runner: runner1, force: jumpForce)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {}
}
