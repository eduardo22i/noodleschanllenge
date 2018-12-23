//
//  Enemy.swift
//  Tea Challenge
//
//  Created by Eduardo Irias on 12/23/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import SpriteKit

enum EnemyState {
    case sleeping, explaining, waiting, thinking, celebrating, crying
}

class Enemy: SKSpriteNode {
    
    var state = EnemyState.sleeping {
        didSet {
            self.removeAllActions()
            
            if oldValue == .sleeping && state == .explaining {
                self.run(SKAction.group([
                    SKAction.wait(forDuration: 4.0),
                    SKAction.animate(with: [SKTexture(imageNamed: "\(self.name!)-Sleeping"), SKTexture(imageNamed: "\(self.name!)-WakeUp")],
                                     timePerFrame: 2.0,
                                     resize: false,
                                     restore: true),
                    ])
                )
            }
            
            if state == .thinking {
                self.texture = SKTexture(imageNamed: "\(self.name!)-ThinkingA1")
                
                let textures = { () -> [SKTexture] in
                    switch Int.random(in: 0 ..< 4) {
                    case 0:
                        return [SKTexture(imageNamed: "\(self.name!)-ThinkingA1"), SKTexture(imageNamed: "\(self.name!)-ThinkingA2")]
                    case 1:
                        return [SKTexture(imageNamed: "\(self.name!)-ThinkingA2"),
                                SKTexture(imageNamed: "\(self.name!)-ThinkingA3")]
                    case 2:
                        return [SKTexture(imageNamed: "\(self.name!)-ThinkingA3"), SKTexture(imageNamed: "\(self.name!)-ThinkingA4")]
                    case 4:
                        return [SKTexture(imageNamed: "\(self.name!)-ThinkingA1"), SKTexture(imageNamed: "\(self.name!)-ThinkingA4")]
                    default:
                        return [SKTexture(imageNamed: "\(self.name!)-ThinkingA1"), SKTexture(imageNamed: "\(self.name!)-ThinkingA2")]
                    }
                }()
                
                self.run(
                    SKAction.repeatForever(
                        SKAction.animate(with: textures,
                                         timePerFrame: 0.5,
                                         resize: false,
                                         restore: true)
                    )
                )
            }
            
            if state == .waiting {
                
                self.texture = SKTexture(imageNamed: "\(self.name!)-Waiting")
                
                let textures = { () -> [SKTexture] in
                    switch Int.random(in: 0 ..< 2) {
                    case 0:
                        return [SKTexture(imageNamed: "\(self.name!)-WaitingB1"), SKTexture(imageNamed: "\(self.name!)-WaitingB2")]
                    default:
                        return [SKTexture(imageNamed: "\(self.name!)-Waiting"), SKTexture(imageNamed: "\(self.name!)-No")]
                    }
                }()
                
                self.run(
                    SKAction.repeatForever(
                        SKAction.animate(with: textures,
                                         timePerFrame: 0.5,
                                         resize: false,
                                         restore: true)
                    )
                )
            }
            
            if state == .celebrating {
                self.texture = SKTexture(imageNamed: "\(self.name!)-CelebratingA1")
                
                let textures = [SKTexture(imageNamed: "\(self.name!)-CelebratingA1"), SKTexture(imageNamed: "\(self.name!)-CelebratingA2"),
                                SKTexture(imageNamed: "\(self.name!)-CelebratingA3")]
                
                self.run(
                    SKAction.repeatForever(
                        SKAction.animate(with: textures,
                                         timePerFrame: 0.3,
                                         resize: false,
                                         restore: true)
                    )
                )
            }
            
            if state == .crying {
                self.texture = SKTexture(imageNamed: "\(self.name!)-SurpriseA1")
                
                let textures = [SKTexture(imageNamed: "\(self.name!)-SurpriseA1"), SKTexture(imageNamed: "\(self.name!)-SurpriseA2")]
                
                self.run(
                    SKAction.repeatForever(
                        SKAction.animate(with: textures,
                                         timePerFrame: 0.5,
                                         resize: false,
                                         restore: true)
                    )
                )
            }
        }
    }
    
    init(name: String) {
        let texture = SKTexture(imageNamed: "\(name)-Waiting")
        super.init(texture: texture, color: NSColor.clear, size: texture.size())
        
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func wakeUp() {
         self.state = .explaining
    }
    
    func wait() {
        self.state = .waiting
    }
}