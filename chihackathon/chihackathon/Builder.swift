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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func placePlatform() -> Bool {
        return placeItem(coinsRequired: Constants.coinPlaceHolder)
    }
    
    func placeSpeedBoost() -> Bool {
        return placeItem(coinsRequired: Constants.coinPlaceHolder)
    }
    
    func placeJumpBoost() -> Bool {
        return placeItem(coinsRequired: Constants.coinPlaceHolder)
    }
    
    func placeWall() -> Bool {
        return placeItem(coinsRequired: Constants.coinPlaceHolder)
    }
    
    func placeMissile() -> Bool {
        return placeItem(coinsRequired: Constants.coinPlaceHolder)
    }
    
    func placeSpeedTrap() -> Bool {
        return placeItem(coinsRequired: Constants.coinPlaceHolder)
    }
    
    func placeItem(coinsRequired: Int) -> Bool {
        if (team.getCoins() > coinsRequired) {
            team.deductCoins(coinsToDeduct: coinsRequired)
            return true
        }else{
            return false
        }
    }
    
}
