//
//  GameScene.swift
//  PauseGame
//
//  Created by Kyle Wilson on 2020-03-25.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var kirby: SKSpriteNode!
    var kirbyFrames: [SKTexture] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        kirby = aDecoder.decodeObject(forKey: "kirby") as? SKSpriteNode
        kirbyFrames = (aDecoder.decodeObject(forKey: "kirbyFrames") as? [SKTexture])!
        print("KIRBY: \(kirby)")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encode(kirby, forKey: "kirby")
        aCoder.encode(kirbyFrames, forKey: "kirbyFrames")
    }
    
    override func didMove(to view: SKView) {
        self.name = "KIRBY GAME"
        let button = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 30))
        button.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        button.name = "pause"
        addChild(button)
        createAnimation()
        makeKirby()
        runAnimation()
        kirby.name = "Kirby"
    }
    
    func makeKirby() {
        let firstFrameTexture = kirbyFrames[0]
        kirby = SKSpriteNode(texture: firstFrameTexture)
        kirby.size = CGSize(width: 50, height: 50)
        kirby.position = CGPoint(x: frame.midX, y: frame.midY + 150)
        addChild(kirby)
    }
    
    func createAnimation() {
        let animation = SKTextureAtlas(named: "kirby")
        var frames: [SKTexture] = []
        
        let numImages = animation.textureNames.count
        for i in 1...numImages {
            let textureName = "kirby-\(i)"
            frames.append(animation.textureNamed(textureName))
        }
        kirbyFrames = frames
    }
    
    func runAnimation() {
        kirby.run(SKAction.repeatForever(SKAction.animate(with: kirbyFrames, timePerFrame: 0.1)))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let nodesArray = nodes(at: location)
            
            for node in nodesArray {
                if node.name == "pause" {
                    self.isPaused = true
                    sceneDidEnterBackground()
                    let secondScene = SecondGameScene(size: (view?.bounds.size)!)
                    secondScene.scaleMode = .aspectFill
                    secondScene.alpha = 0.7
                    scene?.view?.presentScene(secondScene)
                }
            }
        }
    }
    
    @objc func sceneDidEnterBackground() {
        print("working")
        let sceneData = try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        print("Saving Scene Data: \(sceneData)")
        UserDefaults.standard.set(sceneData, forKey: "currentScene")
    }
    
    class func loadScene() -> SKScene? {
        var scene: SKScene?
        
        if let savedSceneData = UserDefaults.standard.object(forKey: "currentScene") as? Data {
            guard let savedScene = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedSceneData) as? GameScene
                else {
                    print("nil")
                    return nil
            }
            print("SAVED SCENE: \(savedScene)")
            print("SAVED SCENE DATA: \(savedSceneData)")
            print("LOADED SCENE")
            scene = savedScene
            print("SCENE SIZE: \(scene?.size)")
        } else {
            scene = nil
        }
        
        return scene
    }
}
