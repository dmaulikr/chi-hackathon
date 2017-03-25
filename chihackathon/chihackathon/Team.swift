//
//  Team.swift
//  chihackathon
//
//  Created by Adam Haag on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation

class Team {
    
    private var id: Int
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
    
    init(id: Int){
        self.id = id
    }
    
    func getCoins() -> Int {
        return self.coins
    }
    
    func deductCoins(coinsToDeduct: Int) {
        self.coins = self.coins - coinsToDeduct
    }
    
    func addCoins(coinsToAdd: Int){
        self.coins = self.coins + coinsToAdd
    }
    
}
