//
//  Team.swift
//  chihackathon
//
//  Created by Adam Haag on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation

class Team {
    
    let runner : Runner = Runner()
    let builder : Builder = Builder()
    private var coins = 0
    var time = 0
    
    enum color {
        case blue
        case green
        case red
        case yellow
        case orange
        case purple
    }
    
    func getCoins() -> Int {
        return self.coins
    }
    
    func deductCoins(coinsToDeduct: Int) {
        self.coins = self.coins - coinsToDeduct
    }
}
