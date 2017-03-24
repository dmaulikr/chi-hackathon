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


    override init(texture: SKTexture!, color: SKColor, size: CGSize, name: String, number: Int, team: Team) {
        super.init(texture: texture, color: color, size: size, name: name, number: number, team: team)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func canPlacePlatform() -> Bool {
        return team.getCoins() > Constants.coinsNeededForPlatform
    }

    func canPlaceSpeedBoost() -> Bool {
        return team.getCoins() > Constants.coinsNeededForSpeedBoost
    }

    func canPlaceJumpBoost() -> Bool {
        return team.getCoins() > Constants.coinsNeededForJumpBoost
    }

    func canPlaceWall() -> Bool {
        return team.getCoins() > Constants.coinsNeededForWall
    }

    func canPlaceMissile() -> Bool {
        return team.getCoins() > Constants.coinsNeededForMissile
    }

    func canPlaceSpeedTrap() -> Bool {
        return team.getCoins() > Constants.coinsNeededForSpeedTrap
    }

    func completeItemPlacement(coinAmount: Int){
        team.deductCoins(coinsToDeduct: coinAmount)
    }

}
