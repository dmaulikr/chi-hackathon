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

    var runner1 = Runner(texture: SKTexture(), color: SKColor.red, size: CGSize(width: Constants.runnerCharacterWidth, height: Constants.runnerCharacterHeight), name: "runner1", number: 1, team: Team(id: 1))
    var runner2 = Runner(texture: SKTexture(), color: SKColor.blue, size: CGSize(width: Constants.runnerCharacterWidth, height: Constants.runnerCharacterHeight), name: "runner2", number: 2, team: Team(id: 2))
    var runners: [Runner]?

    var player: Runner?

    //Sounds
    let soundCoin = SKAction.playSoundFileNamed("CoinPickup.mp3", waitForCompletion: true)
    let soundJump = SKAction.playSoundFileNamed("Jump.mp3", waitForCompletion: true)
    let soundPowerup = SKAction.playSoundFileNamed("Powerup.mp3", waitForCompletion: true)

    // MARK: Init
    override func didMove(to view: SKView) {
        gcManager.gameScene = self

        //audioManager.playBackgroundMusic(filename: "Dreamcatcher")

        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        camera = runnerCamera
        lastUpdateTime = 0

        setupRunners()
        runners?[0].walkingCharacter()
        runners?[1].walkingCharacter()

        assignPlayer()
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
                runner.position = CGPoint(x: 0, y: 200)
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

        if player!.physicsBody?.velocity.dy == 0 {
            ableToJump = true
            player!.lastSecureYPos = player!.position.y
        }else {
            ableToJump = false
        }

        for runner in runners! {
            if runner.position == childNode(withName: "Coin")!.position {
                childNode(withName: "Coin")?.removeFromParent()
                onCoinPickup(runner: runner)
            }
            if runner.position.y < -2400 {
                fall(runner: runner)
            }
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

    var ableToJump = true
    var jumpForce = CGFloat(200.0)

    func jump(runner: Runner, force: CGFloat){
        if ableToJump == true {
            print(force)

            sendJump(force: force)

            run(soundJump)
            runner.physicsBody?.applyImpulse(CGVector(dx: 0, dy: force))
        }
    }

    private func sendJump(force: CGFloat) {
        var message = ""
        if player == runner1 {
            message = "runner1DidJump:\(force)"
        }
        else if player == runner2 {
            message = "runner2DidJump:\(force)"
        }

        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        gcManager.sendDataFast(data: data)
    }

    func fall(runner: Runner){
            runner.die()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in (touches){
            let timerAction = SKAction.wait(forDuration: 0.05)
            let update = SKAction.run({
                if(self.jumpForce < Constants.maxJumpForce){
                    self.jumpForce += 25.0
                }else{
                    self.jumpForce = Constants.maxJumpForce
                    self.jump(runner: self.player!, force: Constants.maxJumpForce)
                }
            })
            let sequence = SKAction.sequence([timerAction, update])
            let repeatSeq = SKAction.repeatForever(sequence)
            self.run(repeatSeq, withKey: "holdJump")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.removeAction(forKey: "holdJump")
        self.jump(runner: player!, force: self.jumpForce)
        self.jumpForce = Constants.minJumpForce

    }

}
