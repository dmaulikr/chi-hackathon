//
//  GameViewController.swift
//  chihackathon
//
//  Created by Derrick Hunt on 3/24/17.
//  Copyright © 2017 Sapient. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentGameScene()
    }
    
    private func presentGameScene() {
        if let scene = SKScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            
            if let view = self.view as! SKView? {
                view.showsFPS = true
                view.showsNodeCount = true
                view.ignoresSiblingOrder = true
                
                view.presentScene(scene)
            }
        }
    }

}
