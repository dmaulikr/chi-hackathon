//
//  Builder.swift
//  chihackathon
//
//  Created by Shitiz Gupta on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import SpriteKit

class Builder {
    
    var team: Team!
    
    init(team: Team) {
        self.team = team
    }

    func canPlacePlatform() -> Bool {
        return team.coins > Constants.coinsNeededForPlatform
    }

    func canPlaceSpeedBoost() -> Bool {
        return team.coins > Constants.coinsNeededForSpeedBoost
    }

    func canPlaceJumpBoost() -> Bool {
        return team.coins > Constants.coinsNeededForJumpBoost
    }

    func canPlaceWall() -> Bool {
        return team.coins > Constants.coinsNeededForWall
    }

    func canPlaceMissile() -> Bool {
        return team.coins > Constants.coinsNeededForMissile
    }

    func canPlaceSpeedTrap() -> Bool {
        return team.coins > Constants.coinsNeededForSpeedTrap
    }

    func completeItemPlacement(cost: Int){
        team.coins -= cost
    }

}
