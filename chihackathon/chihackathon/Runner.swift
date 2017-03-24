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
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize, name: String, number: Int) {
        super.init(texture: texture, color: color, size: size, name: name, number: number)
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
    
    
    // MARK: - Action methods
    func applySpeedBoost() {
        // need start timer
        
        // apply boost
        speedBoostEnabled = true
        currentSpeed = boostSpeed
        
        //timer end
        
        endSpeedBoost()
        
    }
    
    func applyJumpBoost() {
        
    }
    
    func pickUpCoin() {
        
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
    
    
}

