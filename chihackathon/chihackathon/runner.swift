//
//  runner.swift
//  chihackathon
//
//  Created by Johnathon Karcz on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation

class Runner : Player {
    // MARK: - Variables
    var currentSpeed: Double = Constants.playerSpeed
    var onGround : Bool = true
    var lastSafePosition : Point?
    var speedBoostEnabled = false
    
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

