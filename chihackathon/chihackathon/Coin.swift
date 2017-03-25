//
//  Coin.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import SpriteKit

class Coin: Interactables {
    
    override func didMoveToScene() {
        super.didMoveToScene()
        isUserInteractionEnabled = true
        physicsBody = SKPhysicsBody(circleOfRadius: size.height/2)
        physicsBody?.affectedByGravity = false
        physicsBody?.categoryBitMask = PhysicsCategory.Coin
        physicsBody?.contactTestBitMask = PhysicsCategory.Runner
        physicsBody?.collisionBitMask = PhysicsCategory.Runner
    }
    
    override func interact() {
        super.interact()
        print("INTERACTED")
        run(SKAction.sequence([
            SKAction.removeFromParent()
            ]))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        interact()
    }
}
