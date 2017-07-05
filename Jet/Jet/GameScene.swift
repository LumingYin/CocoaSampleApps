//
//  GameScene.swift
//  Jet
//
//  Created by Bright on 7/2/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let jetCategory:UInt32 = 2
    let spikesCategory:UInt32 = 3
    
    let characters = ["A", "B", "C", "D", "E", "1", "2", "3", "4"]
    let keyCodes = [0, 11, 8, 2, 14, 18, 19, 20, 21]
    var currentCharacter: String?
    var currentKeyCode: Int?
    
    private var label : SKLabelNode?
    private var jet: SKSpriteNode?
    private var startButton: SKSpriteNode?
    private var scoreLabel: SKLabelNode?
    private var highScoreLabel: SKLabelNode?
    
    var score = 0
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            //            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        self.jet = self.childNode(withName: "jet") as? SKSpriteNode
        self.startButton = self.childNode(withName: "startButton") as? SKSpriteNode
        self.scoreLabel = self.childNode(withName: "scoreLabel") as? SKLabelNode
        self.highScoreLabel = self.childNode(withName: "highScoreLabel") as? SKLabelNode
        self.scoreLabel?.text = "Score: \(score)"
        updateHighScore()
    }
    
    func startGame() {
        score = 0
        self.scoreLabel?.text = "Score: \(score)"
        if let jet = self.jet {
            jet.position = CGPoint(x: 0, y: 100)
            jet.physicsBody?.pinned = false
            self.startButton?.removeFromParent()
            score = 0
            chooseNextKey()
        }
    }
    
    func updateHighScore() {
        let highScore = UserDefaults.standard.integer(forKey: "highScore")
        self.highScoreLabel?.text = "High: \(highScore)"
    }
    
    override func mouseDown(with event: NSEvent) {
        // get where they clciked
        let point = event.location(in: self)
        let nodesAtPoint = nodes(at: point)
        for node in nodesAtPoint {
            if node.name == "startButton" {
                print("start button clicked")
                startGame()
            }
        }
    }
    
    override func keyDown(with event: NSEvent) {
        if let keyCode = currentKeyCode {
            switch event.keyCode {
            case UInt16(keyCode):
                if let jet = self.jet {
                    jet.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (200 - score * 5)))
                    score += 1
                    scoreLabel?.text = "Score: \(score)"
                    chooseNextKey()
                }
            default:
                print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        print("Collided!")
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == spikesCategory || bodyB.categoryBitMask == spikesCategory {
            print("ran into spikes")
            if (startButton?.parent != self) {
                if let startButton = self.startButton {
                    addChild(startButton)
                    currentCharacter = nil
                    currentKeyCode = nil
                    label?.alpha = 0.0
                    
                    // check if high score
                    let highScore = UserDefaults.standard.integer(forKey: "highScore")
                    if score > highScore {
                        highScoreLabel?.text = "High: \(score)"
                        UserDefaults.standard.set(score, forKey: "highScore")
                        UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func chooseNextKey() {
        let count = UInt32(characters.count)
        let randomIndex = Int(arc4random_uniform(count))
        currentCharacter = characters[randomIndex]
        currentKeyCode = keyCodes[randomIndex]
        if let label = self.label {
            label.text = currentCharacter
            label.alpha = 1.0
        }
    }
}
