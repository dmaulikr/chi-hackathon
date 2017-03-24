//
//  Player.swift
//  chihackathon
//
//  Created by Shitiz Gupta on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    public var playername: String
    private var number: Int
    public var team: Team

    
    init(texture: SKTexture!, color: SKColor, size: CGSize, name: String, number: Int, team: Team) {
        self.playername = name
        self.number = number
        self.team = team
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getName() -> String {
        return self.playername
    }
    
    func getNumber() -> Int {
        return self.number
    }
    
}
