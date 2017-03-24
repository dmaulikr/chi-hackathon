//
//  Builder.swift
//  chihackathon
//
//  Created by Shitiz Gupta on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import SpriteKit

class Builder: Player {
    
    private var team: Team
    
    init(team: Team) {
        self.team = team
    }
    
    func placePlatform() -> Bool {
        return placeItem() //Add the #coins associated w/ platform
    }
    
    func placeSpeedBoost() -> Bool {
        return placeItem()
    }
    
    func placeJumpBoost() -> Bool {
        return placeItem()
    }
    
    func placeWall() -> Bool {
        return placeItem()
    }
    
    func placeMissile() -> Bool {
        return placeItem()
    }
    
    func placeSpeedTrap() -> Bool {
        return placeItem()
    }
    
    func placeItem(coinsRequired: Int) -> Bool {
        if (team.getCoins() > coinsRequired) {
            team.deductCoins(coinsRequired)
            return true
        }else{
            return false
        }
    }
    
}
