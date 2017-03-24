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
    
    func setTeam(team: Team) {
        self.team = team
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func canPlacePlatform() -> Bool {
        return canPlaceItem(coinsRequired: Constants.coinsNeededForPlatform)
    }
    
    func canPlaceSpeedBoost() -> Bool {
        return canPlaceItem(coinsRequired: Constants.coinsNeededForSpeedBoost)
    }
    
    func canPlaceJumpBoost() -> Bool {
        return canPlaceItem(coinsRequired: Constants.coinsNeededForJumpBoost)
    }
    
    func canPlaceWall() -> Bool {
        return canPlaceItem(coinsRequired: Constants.coinsNeededForWall)
    }
    
    func canPlaceMissile() -> Bool {
        return canPlaceItem(coinsRequired: Constants.coinsNeededForMissile)
    }
    
    func canPlaceSpeedTrap() -> Bool {
        return canPlaceItem(coinsRequired: Constants.coinsNeededForSpeedTrap)
    }
    
    func canPlaceItem(coinsRequired: Int) -> Bool {
        return team.getCoins() > coinsRequired
    }
    
    func completeItemPlacement(coinAmount: Int){
        team.deductCoins(coinsToDeduct: coinAmount)
    }
    
}
