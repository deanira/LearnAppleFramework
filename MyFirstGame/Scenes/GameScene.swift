//
//  GameScene.swift
//  MyFirstGame
//
//  Created by Deanira Fadrinaldi on 25/05/23.
//

import Foundation
import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate{
    let background = SKSpriteNode(imageNamed: "bg")
    let ball = SKSpriteNode(imageNamed: "ball")
    let trump = SKSpriteNode(imageNamed: "trump")
    let obama = SKSpriteNode(imageNamed: "obama")
    var gameLogicDelegate: GameLogicDelegate? = nil
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        background.setScale(0.85)
        addChild(background)
        
        ball.name = "ball"
        ball.position = CGPoint(x: size.width/2, y: size.height/2)
        ball.zPosition = 10
        ball.size = CGSize(width: 80, height: 80)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.friction = 0
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
        addChild(ball)
        ball.physicsBody?.applyImpulse(CGVector(dx: -150, dy: 150))
        
        trump.position = CGPoint(x: size.width - 50, y: size.height/2)
        trump.zPosition = 10
        trump.size = CGSize(width: 100, height: 100)
        trump.physicsBody = SKPhysicsBody(rectangleOf: trump.size)
        trump.physicsBody?.friction = 0
        trump.physicsBody?.restitution = 1
        trump.physicsBody?.linearDamping = 0
        trump.physicsBody?.angularDamping = 0
        trump.physicsBody?.allowsRotation = true
        trump.physicsBody?.isDynamic = false
        addChild(trump)
        
        obama.position = CGPoint(x: 50, y: size.height/2)
        obama.zPosition = 10
        obama.size = CGSize(width: 100, height: 100)
        obama.physicsBody = SKPhysicsBody(rectangleOf: trump.size)
        obama.physicsBody?.friction = 0
        obama.physicsBody?.restitution = 1
        obama.physicsBody?.linearDamping = 0
        obama.physicsBody?.angularDamping = 0
        obama.physicsBody?.allowsRotation = true
        obama.physicsBody?.isDynamic = false
        addChild(obama)
        
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        self.physicsBody = frame
        self.name = "scene"
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if ball.position.x > trump.position.x {
            self.addPointObama()
        } else if ball.position.x < obama.position.x {
            self.addPointTrump()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeB.name == "ball" && nodeA.name == "scene" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let loc = touch.location(in: self)
            
            if let scene = scene{
                if loc.x > (scene.size.width / 2){
                    trump.position.y = loc.y
                }else{
                    obama.position.y = loc.y
                }
            }
            
        }
    }
    
    private func addPointObama() {
        if var gameLogicDelegate = self.gameLogicDelegate {
            gameLogicDelegate.addPointObama()
        }
    }
    
    private func addPointTrump() {
        if var gameLogicDelegate = self.gameLogicDelegate {
            gameLogicDelegate.addPointTrump()
        }
    }
}
