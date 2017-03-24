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
    
    init?(team: Team) {
        super.init(coder: <#T##NSCoder#>)
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
        if (team.getCoins() > coinsRequired) {
            return true
        }else{
            return false
        }
    }
    
    func completeItemPlacement(coinAmount: Int){
        team.deductCoins(coinsToDeduct: coinAmount)
    }
    
}
