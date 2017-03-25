//
//  Coin.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import SpriteKit

class Coin: Interactables {
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupPhysics()
    }
    
    func setupPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: size.height/2)
        physicsBody?.isDynamic = false
        physicsBody?.affectedByGravity = false
        physicsBody?.usesPreciseCollisionDetection = true
        physicsBody?.categoryBitMask = PhysicsCategory.Coin
        physicsBody?.contactTestBitMask = PhysicsCategory.Runner
        physicsBody?.collisionBitMask = 0x0
    }

}
