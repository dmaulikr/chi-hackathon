//
//  constants.swift
//  chihackathon
//
//  Created by Johnathon Karcz on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import SpriteKit

struct Constants {
    
    // Runner Constants
    static let playerSpeed: CGFloat = 7
    static let gravity: CGFloat = 1.0
    static let maxJumpForce: CGFloat = 350
    static let minJumpForce: CGFloat = 150
    static let runnerCharacterWidth: Int = 69
    static let runnerCharacterHeight: Int = 69
    
    // Coins Required Constants
    static let coinsNeededForPlatform: Int = 2
    static let coinsNeededForSpeedBoost: Int = 2
    static let coinsNeededForJumpBoost: Int = 2
    static let coinsNeededForWall: Int = 2
    static let coinsNeededForMissile: Int = 2
    static let coinsNeededForSpeedTrap: Int = 2
    
    // Timeouts
    static let speedBoostTimeout: TimeInterval = 1.0
    static let jumpBoostTimeout: TimeInterval = 1.0
    static let deadTimeout: TimeInterval = 15.0

}
