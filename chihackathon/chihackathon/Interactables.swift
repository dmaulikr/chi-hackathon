//
//  Interactables.swift
//  chihackathon
//
//  Created by Adam Haag on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import SpriteKit

class Interactables: SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        isUserInteractionEnabled = true
    }
    
    func interact() {
        isUserInteractionEnabled = true
    }
}
