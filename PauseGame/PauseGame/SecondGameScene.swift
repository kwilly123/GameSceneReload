//
//  SecondGameScene.swift
//  PauseGame
//
//  Created by Kyle Wilson on 2020-03-25.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import SpriteKit
import GameplayKit

class SecondGameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let button = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 30))
        button.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        button.name = "go back"
        addChild(button)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = nodes(at: location)
            
            for node in nodesArray {
                if node.name == "go back" {
                    if let rootScene = GameScene.loadScene() {
                        print("SUCCESS: \(rootScene)")
                        scene!.scaleMode = .aspectFill
                        scene?.view?.presentScene(rootScene)
                    } else {
                        print("FAILED")
                    }
                }
            }
        }
    }
}
