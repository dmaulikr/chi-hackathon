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

class Runner : Player, EventListenerNode, InteractiveNode {
    
    // MARK: - Variables
    var currentSpeed: Double = Constants.playerSpeed
    var onGround : Bool = true
    var lastSafePosition : CGPoint?
    var speedBoostEnabled = false
    var jumpBoostEnabled = true
    var gravity = 1.0
    
    //var character : SKSpriteNode!
    var characterWalkingFrames : [SKTexture]!
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize, name: String, number: Int, team: Team) {
        super.init(texture: texture, color: color, size: size, name: name, number: number, team: team)
        
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
    
    var boostSpeed: Double {
        get {
            if speedBoostEnabled {
                return currentSpeed * 1.5
            }
            else {
                return Constants.playerSpeed
            }
        }
    }
    
    var boostJump: Double {
        get {
            if jumpBoostEnabled {
                return 0.75
            }
            else {
                return Constants.gravity
            }
        }
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
        currentSpeed = boostSpeed
        
        //timer end
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.jumpBoostTimeout) {
            self.endSpeedBoost()
        }
        
    }
    
    func applyJumpBoost() {
        jumpBoostEnabled = true
        gravity = boostJump
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Constants.jumpBoostTimeout) {
            self.endJumpBoost()
        }
        
    }
    
    func pickUpCoin() {
        team.addCoins(coinsToAdd: 1)
    }
    
    func die() {
        
    }
    
    func reset() {
        
    }
    
    
    // MARK: - Private Methods
    private func endSpeedBoost() {
        speedBoostEnabled = false
        currentSpeed = boostSpeed
    }
    
    private func endJumpBoost() {
        jumpBoostEnabled = false
        currentSpeed = boostJump
    }
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.Runner
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.Coin
    }
    
    func interact() {
        
    }
}

