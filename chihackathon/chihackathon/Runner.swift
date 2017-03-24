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

class Runner : Player {
    
    // MARK: - Variables
    var currentSpeed: Double = Constants.playerSpeed
    var onGround : Bool = true
    var lastSafePosition : CGPoint?
    var speedBoostEnabled = false
    var jumpBoostEnabled = true
    var gravity = 1.0
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize, name: String, number: Int, team: Team) {
        super.init(texture: texture, color: color, size: size, name: name, number: number, team: team)
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
    
    
}

