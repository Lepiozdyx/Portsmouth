//
//  IntersectionNode.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import SpriteKit
import UIKit

class IntersectionNode: SKSpriteNode {
    
    // MARK: - Properties
    
    let id: UUID
    
    // MARK: - Initialization
    
    init(intersection: Intersection) {
        self.id = intersection.id
        
        // Создаем временную текстуру для перекрестка
        let size = CGSize(width: 30, height: 30) // Размер перекрестка
        
        super.init(texture: nil, color: .yellow, size: size)
        
        // Настраиваем внешний вид перекрестка для отладки
        // Позже заменим на реальные текстуры
        self.alpha = 0.5 // Полупрозрачный для отладки
        
        // Настраиваем позицию
        self.position = intersection.position
        self.name = "intersection_\(id.uuidString)"
        
        // Настраиваем физическое тело
        setupPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Physics setup
    
    private func setupPhysicsBody() {
        // Используем физическое тело немного меньше видимого размера
        // для более точного определения пересечений
        physicsBody = SKPhysicsBody(circleOfRadius: size.width * 0.4)
        physicsBody?.isDynamic = false  // Перекресток статичен
        physicsBody?.categoryBitMask = ShipNode.PhysicsCategory.intersection
        physicsBody?.contactTestBitMask = ShipNode.PhysicsCategory.ship
        physicsBody?.collisionBitMask = 0  // Нет коллизий, только контакты
    }
    
    // Показываем индикатор перекрестка для отладки
    func showIntersectionIndicator() {
        // Удаляем существующие индикаторы
        childNode(withName: "intersectionIndicator")?.removeFromParent()
        
        // Создаем индикатор перекрестка
        let indicator = SKShapeNode(circleOfRadius: 5)
        indicator.fillColor = .green
        indicator.name = "intersectionIndicator"
        
        addChild(indicator)
    }
}
