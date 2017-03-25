//
//  runner.swift
//  chihackathon
//
//  Created by Johnathon Karcz on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class Runner: SKSpriteNode {
    
    let gcManager = GameCenterManager.sharedInstance
    
    var team: Team!
    var playerName: String!
    var textureAtlas: [SKTexture]!
    
    var onGround = false
    var lastSafePosition = CGPoint()
    var lastSecureYPos: CGFloat = 0
    var deaths = 0
    
    var speedBoostEnabled = false
    var speedBoostTimer = Timer()
    var speedBoostParticleEmitter = SKEmitterNode()
    
    var jumpBoostEnabled = false
    var jumpBoostTimer = Timer()
    var jumpBoostParticleEmitter = SKEmitterNode()
    
    var speedMultiplier: CGFloat {
        get {
            if speedBoostEnabled {
                return 3
            }
            else {
                return 1
            }
        }
    }
    
    var jumpMultiplier: CGFloat {
        get {
            if jumpBoostEnabled {
                return 2
            }
            else {
                return 1
            }
        }
    }
    
    let soundJump = SKAction.playSoundFileNamed("Jump.mp3", waitForCompletion: true)
    let soundCoin = SKAction.playSoundFileNamed("CoinPickup.mp3", waitForCompletion: true)
    let soundPowerup = SKAction.playSoundFileNamed("Powerup.mp3", waitForCompletion: true)
    
    init(team: Team, playerName: String) {
        super.init(texture: nil, color: SKColor.white, size: CGSize(width: Constants.runnerCharacterWidth, height: Constants.runnerCharacterHeight))
        self.team = team
        self.playerName = playerName
        
        setPhysics()
        setTextures()
        setColorTint()
        addLabelNode()
        addEmitters()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setPhysics() {
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        
        //parent!.physicsBody!.categoryBitMask = PhysicsCategory.Runner
        //parent!.physicsBody!.collisionBitMask = PhysicsCategory.Coin
    }
    
    private func setTextures() {
        let characterAnimatedAtlas = SKTextureAtlas(named: "PlayerCharacter")
        var walkFrames = [SKTexture]()
        
        let numImages = characterAnimatedAtlas.textureNames.count
        for i in 1..<numImages/2 {
            let characterTextureName = "PlayerCharacter-\(i)@2x~ipad.png"
            walkFrames.append(characterAnimatedAtlas.textureNamed(characterTextureName))
        }
        textureAtlas = walkFrames
        
        let firstFrame = textureAtlas[0]
        self.texture = firstFrame
    }
    
    private func setColorTint() {
        colorBlendFactor = 0.75
        color = team.color
    }
    
    private func addLabelNode() {
        let labelNode = SKLabelNode()
        labelNode.position.y = 40
        labelNode.fontColor = team.color
        labelNode.text = playerName
        addChild(labelNode)
    }
    
    private func addEmitters() {
        let speedBoostParticle = Bundle.main.path(forResource: "RedFireParticle", ofType: "sks")!
        speedBoostParticleEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: speedBoostParticle) as! SKEmitterNode
        speedBoostParticleEmitter.position.x = -40
        speedBoostParticleEmitter.alpha = 0
        addChild(speedBoostParticleEmitter)
        
        let jumpBoostParticle = Bundle.main.path(forResource: "BlueFireParticle", ofType: "sks")!
        jumpBoostParticleEmitter = NSKeyedUnarchiver.unarchiveObject(withFile: jumpBoostParticle) as! SKEmitterNode
        jumpBoostParticleEmitter.position.y = -40
        jumpBoostParticleEmitter.alpha = 0
        addChild(jumpBoostParticleEmitter)
    }
    
    // MARK: Animations
    func playWalkAnimation() {
        run(SKAction.repeatForever(SKAction.animate(with: textureAtlas, timePerFrame: 0.1, resize: false, restore: true)), withKey:"walkingInPlaceCharacter")
    }
    
    // MARK: Game Actions
    func jump(force: CGFloat) {
        //if onGround {
            var jumpForce = force
            if jumpBoostEnabled {
                jumpForce *= jumpMultiplier
            }
        
            sendJumpData(force: jumpForce)
        
            physicsBody?.applyImpulse(CGVector(dx: 0, dy: jumpForce))
            onGround = false
        
            run(soundJump)
        //}
    }
    
    func pickUpCoin() {
        team.coins += 1
    }
    
    func respawn() {
        sendRespawnData(position: lastSafePosition)

        deaths += 1
        
        physicsBody?.velocity.dx = 0
        physicsBody?.velocity.dy = 0
        
        let flashWhite = SKAction.colorize(with: UIColor.white, colorBlendFactor: 0.75, duration: 0.1)
        let flashOriginalColor = SKAction.colorize(with: team.color, colorBlendFactor: 0.75, duration: 0.1)
        let flashSequence = SKAction.sequence([flashWhite, flashOriginalColor, flashWhite, flashOriginalColor, flashWhite, flashOriginalColor])
        run(flashSequence)
    }
    
    // MARK: Powerups
    func applySpeedBoost() {
        sendSpeedBoostData()
        speedBoostEnabled = true
        speedBoostParticleEmitter.run(SKAction.fadeIn(withDuration: 0.1))
        speedBoostTimer = Timer.scheduledTimer(timeInterval: Constants.speedBoostTimeout, target: self, selector: #selector(removeSpeedBoost), userInfo: nil, repeats: false)
    }
    
    func removeSpeedBoost() {
        speedBoostEnabled = false
        speedBoostParticleEmitter.run(SKAction.fadeOut(withDuration: 0.1))
        speedBoostTimer.invalidate()
    }
    
    func applyJumpBoost() {
        sendJumpBoostData()
        jumpBoostEnabled = true
        jumpBoostParticleEmitter.run(SKAction.fadeIn(withDuration: 0.1))
        jumpBoostTimer = Timer.scheduledTimer(timeInterval: Constants.jumpBoostTimeout, target: self, selector: #selector(removeJumpBoost), userInfo: nil, repeats: false)
    }
    
    func removeJumpBoost() {
        jumpBoostEnabled = false
        jumpBoostParticleEmitter.run(SKAction.fadeOut(withDuration: 0.1))
        jumpBoostTimer.invalidate()
    }
    
    // MARK: Networking
    private func sendJumpData(force: CGFloat) {
        let message = "runner\(team.id)DidJump:\(force)"
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        gcManager.sendDataFast(data: data)
    }
    
    private func sendSpeedBoostData() {
        let message = "runner\(team.id)DidUseSpeedBoost"
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        gcManager.sendDataFast(data: data)
    }
    
    private func sendJumpBoostData() {
        let message = "runner\(team.id)DidUseJumpBoost"
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        gcManager.sendDataFast(data: data)
    }
    
    private func sendRespawnData(position: CGPoint) {
        let message = "runner\(team.id)DidRespawn:\(position)"
        let data = NSKeyedArchiver.archivedData(withRootObject: message)
        gcManager.sendDataFast(data: data)
    }
    
}
