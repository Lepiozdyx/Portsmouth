import SpriteKit
import UIKit

class ShipNode: SKSpriteNode {
    // MARK: - Properties
    
    let id: UUID
    let turnPattern: TurnDirection
    let shipSpeed: CGFloat
    var isMoving: Bool = false
    var intersectionsPassed: Int = 0
    
    // Позиция в сетке (row, col)
    var gridPosition: (Int, Int)?
    
    // Категории физических тел для определения столкновений
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let ship: UInt32 = 0x1 << 0
        static let intersection: UInt32 = 0x1 << 1
        static let boundary: UInt32 = 0x1 << 2
        static let obstacle: UInt32 = 0x1 << 3
    }
    
    // MARK: - Initialization
    
    init(ship: Ship) {
        self.id = ship.id
        self.turnPattern = ship.turnPattern
        self.shipSpeed = ship.speed
        
        // Создаем текстуру корабля
        let texture = SKTexture(imageNamed: "ship_placeholder")
        let size = CGSize(width: 40, height: 20)
        
        super.init(texture: texture, color: .yellow, size: size)
        
        // Настраиваем внешний вид
        self.colorBlendFactor = 1.0
        
        // Настраиваем позицию и поворот
        self.position = ship.position
        self.zRotation = ship.rotation
        self.name = "ship_\(id.uuidString)"
        
        // Настраиваем физическое тело
        setupPhysicsBody()
        
        // Показываем индикатор направления
        showTurnPatternIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup methods
    
    private func setupPhysicsBody() {
        // Создаем физическое тело в форме прямоугольника
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = true
        physicsBody?.affectedByGravity = false
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
        physicsBody?.friction = 0
        physicsBody?.restitution = 0
        
        physicsBody?.categoryBitMask = PhysicsCategory.ship
        physicsBody?.contactTestBitMask = PhysicsCategory.intersection |
                                           PhysicsCategory.obstacle |
                                           PhysicsCategory.ship
        physicsBody?.collisionBitMask = PhysicsCategory.boundary |
                                         PhysicsCategory.obstacle |
                                         PhysicsCategory.ship
    }
    
    // MARK: - Movement methods
    
    func startMoving() {
        isMoving = true
        
        // Удаляем индикатор поворота
        removeDirectionIndicator()
        
        // Направление движения на основе текущего вращения
        let dx = cos(zRotation) * shipSpeed
        let dy = sin(zRotation) * shipSpeed
        
        // Применяем постоянную скорость в направлении корабля
        physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
    
    // Метод для поворота налево (против часовой стрелки)
    func turnLeft() {
        // Сохраняем текущую скорость
        let currentSpeed = sqrt(pow(physicsBody?.velocity.dx ?? 0, 2) + pow(physicsBody?.velocity.dy ?? 0, 2))
        
        // Анимация поворота
        let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.2)
        run(rotateAction) { [weak self] in
            guard let self = self else { return }
            
            // Обновляем направление движения
            let dx = cos(self.zRotation) * currentSpeed
            let dy = sin(self.zRotation) * currentSpeed
            
            self.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        }
    }
    
    // Метод для поворота направо (по часовой стрелке)
    func turnRight() {
        // Сохраняем текущую скорость
        let currentSpeed = sqrt(pow(physicsBody?.velocity.dx ?? 0, 2) + pow(physicsBody?.velocity.dy ?? 0, 2))
        
        // Анимация поворота
        let rotateAction = SKAction.rotate(byAngle: -.pi / 2, duration: 0.2)
        run(rotateAction) { [weak self] in
            guard let self = self else { return }
            
            // Обновляем направление движения
            let dx = cos(self.zRotation) * currentSpeed
            let dy = sin(self.zRotation) * currentSpeed
            
            self.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
        }
    }
    
    // Метод для остановки корабля
    func stopMoving() {
        isMoving = false
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    // Отображаем индикатор паттерна поворота корабля
    func showTurnPatternIndicator() {
        // Удаляем существующие индикаторы
        removeDirectionIndicator()
        
        // Создаем стрелку-индикатор
        let arrowNode = SKShapeNode()
        let path = UIBezierPath()
        
        // Определяем форму стрелки в зависимости от паттерна
        switch turnPattern {
        case .left:
            // Стрелка влево
            path.move(to: CGPoint(x: 0, y: -10))
            path.addLine(to: CGPoint(x: -10, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 10))
        case .right:
            // Стрелка вправо
            path.move(to: CGPoint(x: 0, y: -10))
            path.addLine(to: CGPoint(x: 10, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 10))
        case .straight:
            // Стрелка прямо
            path.move(to: CGPoint(x: -5, y: -10))
            path.addLine(to: CGPoint(x: 5, y: -10))
            path.addLine(to: CGPoint(x: 5, y: 5))
            path.addLine(to: CGPoint(x: 10, y: 5))
            path.addLine(to: CGPoint(x: 0, y: 15))
            path.addLine(to: CGPoint(x: -10, y: 5))
            path.addLine(to: CGPoint(x: -5, y: 5))
            path.addLine(to: CGPoint(x: -5, y: -10))
        case .reverse:
            // Разворот
            path.addArc(withCenter: CGPoint.zero,
                       radius: 10,
                       startAngle: 0,
                       endAngle: .pi * 2,
                       clockwise: true)
            
            // Добавляем стрелки на окружность
            path.move(to: CGPoint(x: -5, y: -8))
            path.addLine(to: CGPoint(x: -10, y: -10))
            path.addLine(to: CGPoint(x: -8, y: -5))
            
            path.move(to: CGPoint(x: 5, y: 8))
            path.addLine(to: CGPoint(x: 10, y: 10))
            path.addLine(to: CGPoint(x: 8, y: 5))
        }
        
        arrowNode.path = path.cgPath
        arrowNode.fillColor = .black
        arrowNode.strokeColor = .black
        arrowNode.lineWidth = 1
        arrowNode.name = "turnIndicator"
        arrowNode.position = CGPoint(x: 0, y: 25) // Размещаем над кораблем
        arrowNode.zPosition = 3
        
        addChild(arrowNode)
    }
    
    // Метод для удаления индикатора направления
    func removeDirectionIndicator() {
        childNode(withName: "turnIndicator")?.removeFromParent()
    }
    
    // Метод для анимации столкновения
    func animateCollision() {
        // Останавливаем корабль
        stopMoving()
        
        // Создаем анимацию столкновения
        let redColor = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.2)
        let shake = SKAction.sequence([
            SKAction.rotate(byAngle: 0.1, duration: 0.05),
            SKAction.rotate(byAngle: -0.2, duration: 0.05),
            SKAction.rotate(byAngle: 0.2, duration: 0.05),
            SKAction.rotate(byAngle: -0.1, duration: 0.05)
        ])
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        
        run(SKAction.sequence([
            SKAction.group([redColor, shake]),
            fadeOut
        ]))
    }
}
