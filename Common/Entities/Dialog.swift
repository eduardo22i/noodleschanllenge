//
//  Dialog.swift
//  Noodles Challenge Mac
//
//  Created by Eduardo Irias on 12/24/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import SpriteKit

enum DialogState {
    case wakeUp, instructions, thinking, waiting, celebrating, crying
    
    var texts:[String] {
        switch self {
        case .wakeUp:
            return ["... ZZZ",
                    "Ahh! A new challenger? \nOkay! I Always win!",
                    "Win to me and I'll give you the best NOODLES!"]
        case .instructions:
            return ["The rules are simple. \nWe are going to take turns.",
                    "We have \(GameScene.config.count) boxes,\neach box have different amount of coins.",
                "In your turn, \nremove all the coins you want \nbut only from 1 box.",
                "The player who picks\n the LAST coin from ALL boxes, loses the game.",
                "Please, start!",
            "..."]
        case .waiting:
            return [ "Let me think!",
                     "LOL! What was that move?",
                     "I guess you enjoy making mistakes",
                     "Thanks! I'm closer to my victory",
                     "Let me analyze this..."]
        case .thinking:
            return ["Haha! Scared?",
                    "Please, don't cry!",
                    "Okay... Your turn, try harder!",
                    "Looks like you will lose"]
        case .celebrating:
            return [ "Lalala! I won!"]
        case .crying:
            return [ "OMG! This is not possible! NOOO! \nYou won the NOODLES!"]
        }
    }
}

class Dialog: SKSpriteNode {
    
    var state: DialogState = .wakeUp
    
    var image: SKSpriteNode!
    var text: String = "" {
        didSet {
            let labelNode = self.childNode(withName: "text") as? SKLabelNode
            labelNode?.text = text
        }
    }
    
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

