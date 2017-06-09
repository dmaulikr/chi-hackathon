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

struct PhysicsCategory {
    static let None: UInt32 =   0x1 << 0
    static let Runner: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Coin: UInt32 =   0x1 << 3
    //static let Finish: UInt32 = 0x1 << 4
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
        
//        audioManager.playBackgroundMusic(filename: "Dreamcatcher")
        camera = runnerCamera
        
        setupPhysics()
        setupRunners()
    }
    
    func setupPhysics() {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        enumerateChildNodes(withName: "Coin", using: { node, _ in
            if let coin = node as? SKSpriteNode {
                coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
                coin.physicsBody!.isDynamic = true
                coin.physicsBody!.affectedByGravity = true
                coin.physicsBody!.usesPreciseCollisionDetection = true
                coin.physicsBody!.categoryBitMask = PhysicsCategory.Coin
                coin.physicsBody!.contactTestBitMask = PhysicsCategory.Runner
                coin.physicsBody!.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Runner
            }
        })
        
        enumerateChildNodes(withName: "Tile Map Node", using: { node, _ in
            if let sprite = node as? SKSpriteNode {
                sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
                sprite.physicsBody!.isDynamic = false
                sprite.physicsBody!.affectedByGravity = false
                sprite.physicsBody!.usesPreciseCollisionDetection = true
                sprite.physicsBody!.categoryBitMask = PhysicsCategory.Ground
                sprite.physicsBody!.contactTestBitMask = PhysicsCategory.Runner
                sprite.physicsBody!.collisionBitMask = PhysicsCategory.Runner
            }
        })
    }

    private func setupRunners() {
        runner1 = Runner(team: team1, playerName: "P1")
        runner1.position = CGPoint(x: -400, y: 550)
        
//        runner2 = Runner(team: team2, playerName: "P2")
//        runner1.position = CGPoint(x: -200, y: 550)
//
//        runner3 = Runner(team: team3, playerName: "P3")
//        runner1.position = CGPoint(x: -300, y: 550)
//
//        runner4 = Runner(team: team4, playerName: "P4")
//        runner1.position = CGPoint(x: -400, y: 550)

        runners = [runner1]//, runner2, runner3, runner4]
        
        //runners = Array(runners[0..<gcManager.players!.count + 1])

        for runner in runners {
            addChild(runner)
            runner.lastSafePosition = runner.position
            runner.playWalkAnimation()
        }
        
        assignPlayer()
    }

    private func assignPlayer() {
//        var index = 0
//        for player in gcManager.playerAssignments {
//            if GKLocalPlayer.localPlayer().playerID == player {
//                break
//            }
//
//            index += 1
//        }
//
//        if index == 0 {
//            playerRunner = runner1
//        }
//        else if index == 1 {
//            playerRunner = runner2
//        }
//        else if index == 2 {
//            playerRunner = runner3
//        }
//        else if index == 3 {
//            playerRunner = runner4
//        }
        
        playerRunner = runner1
        playerRunner.addChild(runnerCamera)
    }

    // MARK: Update Loop
    override func update(_ currentTime: TimeInterval) {
        let dt = calculateDT(currentTime: currentTime)

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
    
    private func checkForPlayerRunnerDeath() {
        if playerRunner.position.y <= -2500 {
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
            playerRunner.jump(force: Constants.maxJumpForce / 2)

            
//            let timerAction = SKAction.wait(forDuration: 0.025)
//            let update = SKAction.run {
//                if self.jumpForce < Constants.maxJumpForce {
//                    self.jumpForce += 25.0
//                }
//                else {
//                    self.jumpForce = Constants.maxJumpForce
//                    self.playerRunner.jump(force: self.jumpForce)
//                }
//            }
//        
//            let sequence = SKAction.sequence([timerAction, update])
//            let repeatSeq = SKAction.repeatForever(sequence)
//            run(repeatSeq, withKey: "holdJump")
        }
    }

//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        removeAction(forKey: "holdJump")
//        playerRunner.jump(force: jumpForce)
//        jumpForce = Constants.minJumpForce
//    }
    
    func applySpeedBoost() {
        playerRunner.applySpeedBoost()
    }
    
    func applyJumpBoost() {
        playerRunner.applyJumpBoost()
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    private func collisionBetween(runner: Runner, node: SKNode) {
        print(node.name)
        
        if node.name == "Coin", let coin = node as? SKSpriteNode {
            coin.removeFromParent()
            
            if runner == playerRunner {
                playerRunner.team.coins += 1
            }
        }
        else if (node.name == "Tile Map Node" || node.name == "Ground" || node.name == "Ground "), let ground = node as? SKSpriteNode {
            playerRunner.onGround = true
            
//            let runnerNodeBottomY = runner.position.y - runner.size.height / 2
//            let groundNodeTopY = ground.position.y + ground.size.height / 2
//            
//            if runnerNodeBottomY + 5 >= groundNodeTopY &&
//                runnerNodeBottomY - 5 <= groundNodeTopY {
//                runner.onGround = true
//                runner.lastSafePosition = CGPoint(x: ground.position.x, y: groundNodeTopY + runner.size.height / 2 + 5)
//                
//                print("Touching ground at safe pos: \(runner.lastSafePosition)")
//            }
//            else {
//                runner.onGround = false
//            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let runner = contact.bodyA.node as? Runner {
            collisionBetween(runner: runner, node: contact.bodyB.node!)
        }
        else if let runner = contact.bodyB.node as? Runner {
            collisionBetween(runner: runner, node: contact.bodyA.node!)
        }
        
//        if ((firstBody.categoryBitMask & PhysicsCategory.Runner != 0) &&
//            (secondBody.categoryBitMask & PhysicsCategory.Finish != 0)) {
//            if (contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil) {
//                return
//            }
//            
//            if let runnerNode = firstBody.node as? Runner {
//                if runnerNode == playerRunner {
//                    let winAction = SKAction.run(){
//                        let reveal = SKTransition.flipVertical(withDuration: 0.5)
//                        let gameOverScene = GameOverScene(size: self.size, won: true)
//                        self.view?.presentScene(gameOverScene, transition: reveal)
//                    }
//                    run(winAction)
//                }
//            }
//        }
        
    }
        
}

extension SKNode {
    var positionInScene: CGPoint? {
        if let scene = scene, let parent = parent {
            return parent.convert(position, to:scene)
        }
        else {
            return nil
        }
    }
}
