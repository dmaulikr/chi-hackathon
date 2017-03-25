//
//  Team.swift
//  chihackathon
//
//  Created by Adam Haag on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import SpriteKit

class Team {
    
    var id = 0
    var color = SKColor.red
    var time: TimeInterval = 0
    var coins = 0

    init(id: Int, color: SKColor) {
        self.id = id
        self.color = color
    }
    
}
