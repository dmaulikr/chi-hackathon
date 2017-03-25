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

protocol EventListenerNode {
    func didMoveToScene()
}
protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Coin: UInt32 = 0b1 // 1
    static let Platform: UInt32 = 0b10 // 2
    static let JumpBoost: UInt32 = 0b100 // 4
    static let SpeedBoost: UInt32 = 0b1000 // 8
    static let Wall: UInt32 = 0b10000 // 16
    static let Missile: UInt32 = 0b100000 // 32
    static let SpeedTrap: UInt32 = 0b1000000 // 64
    static let Runner: UInt32 = 0b10000000 // 128
}

class GameScene: SKScene {

    let gcManager = GameCenterManager.sharedInstance
    let audioManager = AudioManager.sharedInstance
    let runnerCamera = SKCameraNode()

    var lastUpdateTime: TimeInterval = 0
    var touched = false
    
    var team1 = Team(id: 1, color: SKColor.red)
    var team2 = Team(id: 2, color: SKColor.blue)
    var team3 = Team(id: 3, color: SKColor.yellow)
    var team4 = Team(id: 4, color: SKColor.green)

    var runner1: Runner!
    var runner2: Runner!
    var runner3: Runner!
    var runner4: Runner!
    var runners = [Runner]()
    var playerRunner: Runner!

    // MARK: Init
    override func didMove(to view: SKView) {
        gcManager.gameScene = self
        //audioManager.playBackgroundMusic(filename: "Dreamcatcher")

        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        camera = runnerCamera
        lastUpdateTime = 0

        setupRunners()
        assignPlayer()
    }

    private func setupRunners() {
        runner1 = Runner(team: team1, playerName: "P1")
        runner2 = Runner(team: team2, playerName: "P2")
        runner3 = Runner(team: team2, playerName: "P3")
        runner4 = Runner(team: team2, playerName: "P4")
        runners = [runner1, runner2, runner3, runner4]
        
        runners = Array(runners[0..<gcManager.players!.count + 1])

        for runner in runners {
            if runner == runner1 {
                runner.position = CGPoint(x: -100, y: 200)
            }
            else if runner == runner2 {
                runner.position = CGPoint(x: -200, y: 200)
            }
            else if runner == runner3 {
                runner.position = CGPoint(x: -300, y: 200)
            }
            else if runner == runner4 {
                runner.position = CGPoint(x: -400, y: 200)
            }
            
            addChild(runner)
            runner.lastSafePosition = runner1.position
            runner.playWalkAnimation()
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
            playerRunner = runner1
        }
        else if index == 1 {
            playerRunner = runner2
        }
        else if index == 2 {
            playerRunner = runner3
        }
        else if index == 3 {
            playerRunner = runner4
        }
        
        playerRunner.addChild(runnerCamera)
    }

    // MARK: Update Loop
    override func update(_ currentTime: TimeInterval) {
        let dt = calculateDT(currentTime: currentTime)

        checkForSafePlayerPosition()
        checkForPlayerRunnerDeath()
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
    
    private func checkForSafePlayerPosition() {
        if playerRunner.onGround {
            playerRunner.lastSafePosition = playerRunner.position
        }
    }
    
    private func checkForPlayerRunnerDeath() {
        if playerRunner.position.y <= -2400 {
            playerRunner.respawn()
            playerRunner.position = playerRunner.lastSafePosition
        }
    }
    
    private func updateRunnerPositions(dt: TimeInterval) {
        for runner in runners {
            let dx = Constants.playerSpeed * runner.speedMultiplier * CGFloat(dt)
            runner.position.x += dx
        }
    }

    // MARK: Input
    var jumpForce = Constants.minJumpForce
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            let timerAction = SKAction.wait(forDuration: 0.025)
            let update = SKAction.run {
                if self.jumpForce < Constants.maxJumpForce {
                    self.jumpForce += 25.0
                }
                else {
                    self.jumpForce = Constants.maxJumpForce
                    self.playerRunner.jump(force: self.jumpForce)
                }
            }
        
            let sequence = SKAction.sequence([timerAction, update])
            let repeatSeq = SKAction.repeatForever(sequence)
            run(repeatSeq, withKey: "holdJump")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeAction(forKey: "holdJump")
        playerRunner.jump(force: jumpForce)
        jumpForce = Constants.minJumpForce
    }
    
    func applySpeedBoost() {
        playerRunner.applySpeedBoost()
    }
    
    func applyJumpBoost() {
        playerRunner.applyJumpBoost()
    }

}
