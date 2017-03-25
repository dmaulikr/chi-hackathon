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

class Runner : SKSpriteNode, EventListenerNode, InteractiveNode {
    
    var team: Team!
    var lastSafePosition = CGPoint()
    var lastSecureYPos: CGFloat = 0
    var onGround = false
    var speedBoostEnabled = false
    var jumpBoostEnabled = false
    var gravity = 1.0
    var timesDead = 0
    
    var characterWalkingFrames: [SKTexture]!
    
    var speedMultiplier: CGFloat {
        get {
            if speedBoostEnabled {
                return 1.5
            }
            else {
                return 1
            }
        }
    }
    
    var jumpMultiplier: CGFloat {
        get {
            if jumpBoostEnabled {
                return 1.5
            }
            else {
                return 1
            }
        }
    }
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, team: Team, name: String) {
        super.init(texture: texture, color: color, size: size)
        self.team = team
        
        let labelNode = SKLabelNode()
        labelNode.position.y = 40
        labelNode.text = name
        addChild(labelNode)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false

        //var characterWalkingFrames : [SKTexture]!
        let characterAnimatedAtlas = SKTextureAtlas(named: "PlayerCharacter")
        var walkFrames = [SKTexture]()
        
        let numImages = characterAnimatedAtlas.textureNames.count
        for i in 1..<numImages/2 {
            let characterTextureName = "PlayerCharacter-\(i)@2x~ipad.png"
            walkFrames.append(characterAnimatedAtlas.textureNamed(characterTextureName))
        }
        characterWalkingFrames = walkFrames
        
        let firstFrame = characterWalkingFrames[0]
        self.texture = firstFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action methods
    func walkingCharacter() {
        //This is our general runAction method to make our character walk.
        run(SKAction.repeatForever(
            SKAction.animate(with: characterWalkingFrames,
                                         timePerFrame: 0.1,
                                         resize: false,
                                         restore: true)),
                            withKey:"walkingInPlaceCharacter")
    }
    
    
    func applySpeedBoost() {
        // need start timer
        
        // apply boost
        speedBoostEnabled = true
        //currentSpeed = boostSpeed
        
        //timer end
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.jumpBoostTimeout) {
            self.endSpeedBoost()
        }
        
    }
    
    func applyJumpBoost() {
        jumpBoostEnabled = true
        //gravity = boostJump
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.jumpBoostTimeout) {
            self.endJumpBoost()
        }
        
    }
    
    func pickUpCoin() {
        team.coins += 1
    }
    
    func die() {
        timesDead += 1
        reset()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.deadTimeout) {
            if self.timesDead > 5 {
                self.lastSecureYPos = self.lastSecureYPos + 100
                self.timesDead = 1
            }
        }
    }
    
    func reset() {
        self.position.y = lastSecureYPos
        
    }
    
    
    // MARK: - Private Methods
    private func endSpeedBoost() {
        speedBoostEnabled = false
        //currentSpeed = boostSpeed
    }
    
    private func endJumpBoost() {
        jumpBoostEnabled = false
        //currentSpeed = boostJump
    }
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.Runner
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.Coin
    }
    
    func interact() {
        
    }
}

