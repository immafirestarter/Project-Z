//
//  Enemy.swift
//  Test
//
//  Created by Ahmed Shehab on 23/06/2017.
//  Copyright © 2017 Sami. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode {
    
    var health = 100
    var hasHit = false
    var attacking = false
    var atlas:SKTextureAtlas?
    static let enemyHitCategory = 1
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        
        let enemyTexture = SKTexture(imageNamed: "ghost1-1")
        let enemySize = CGSize(width: enemyTexture.size().width * 0.4, height: enemyTexture.size().height * 0.4)
        super.init(texture: enemyTexture, color: UIColor.clear, size: enemySize)
        self.physicsBody = SKPhysicsBody(texture: enemyTexture, size: enemySize)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.affectedByGravity = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.restitution = 0
        
        
        self.physicsBody?.categoryBitMask = BodyType.enemy.rawValue
        self.physicsBody?.collisionBitMask = BodyType.player.rawValue | BodyType.projectile.rawValue | BodyType.ground.rawValue
        self.physicsBody?.contactTestBitMask = BodyType.player.rawValue | BodyType.projectile.rawValue | BodyType.ground.rawValue
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func delayHit(){
        hasHit = true
        let when = DispatchTime.now() + 0.2
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.hasHit = false
        }
    }
    
    func setUpEnemyWalk() {
        atlas = SKTextureAtlas(named: "Walk")
        var atlasTextures = [SKTexture]()
        let texture1:SKTexture = atlas!.textureNamed("ghost1-1")
        let texture2:SKTexture = atlas!.textureNamed("ghost2-1")
        let texture3:SKTexture = atlas!.textureNamed("ghost3-1")
        atlasTextures.append(texture1)
        atlasTextures.append(texture2)
        atlasTextures.append(texture3)
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1/15)
        self.run(atlasAnimation)
    }
    
    func enemyWalk(){
        self.physicsBody?.velocity = CGVector(dx: -80, dy: 0)
        setUpEnemyWalk()
    }
    
    class func spawnEnemy(parent: GameScene, xPoint: Int, yPoint: Int) {
        let wait = SKAction.wait(forDuration: 10)
        let spawn = SKAction.run {
            let theEnemy:Enemy = Enemy()
            theEnemy.xScale = fabs(theEnemy.xScale) * -1
            theEnemy.position = CGPoint(x: xPoint, y: yPoint)
        parent.addChild(theEnemy)
        parent.enemies.append(theEnemy)
        }
        
        let constantSpawn = SKAction.sequence([spawn, wait])
        parent.run(SKAction.repeatForever(constantSpawn))

    }
    
    func attack(){
        let kickTexture = SKAction.setTexture(SKTexture(imageNamed: "ghost1-1"))
        let standTexture = SKAction.setTexture(SKTexture(imageNamed: "ghost1-1"))
        let megaAttack = SKAction.sequence([kickTexture, standTexture])
        self.run(megaAttack)
    }            
}
