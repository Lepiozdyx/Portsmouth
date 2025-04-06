import SpriteKit
import UIKit

/// Класс, представляющий корабль в игровой сцене
class ShipNode: SKNode {
    // MARK: - Свойства
    
    /// Идентификатор корабля
    let id: UUID
    
    /// Направление движения корабля
    var direction: ShipDirection
    
    /// Паттерн поворота на перекрестках
    let turnPattern: TurnPattern
    
    /// Флаг, указывающий, движется ли корабль
    var isMoving: Bool = false
    
    /// Визуальное представление корабля
    private let shipSprite: SKSpriteNode
    
    /// Индикатор паттерна поворота
    private let patternIndicator: SKLabelNode
    
    // MARK: - Инициализация
    
    init(size: CGSize, direction: ShipDirection, turnPattern: TurnPattern, id: UUID = UUID()) {
        self.id = id
        self.direction = direction
        self.turnPattern = turnPattern
        
        // Создаем спрайт корабля (треугольник)
        // Обратите внимание, что теперь вершина указывает вверх (0, size.height)
        // вместо предыдущей реализации, где первая точка была (size.width/2, size.height)
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: 0, y: size.height))
        trianglePath.addLine(to: CGPoint(x: 0, y: 0))
        trianglePath.addLine(to: CGPoint(x: size.width, y: size.height/2))
        trianglePath.close()
        
        let shapeNode = SKShapeNode(path: trianglePath.cgPath)
        shapeNode.fillColor = .white
        shapeNode.strokeColor = .black
        shapeNode.lineWidth = 2.0
        
        let texture = SKView().texture(from: shapeNode)
        shipSprite = SKSpriteNode(texture: texture)
        shipSprite.size = size
        
        // Создаем индикатор паттерна поворота
        patternIndicator = SKLabelNode(fontNamed: "Helvetica-Bold")
        patternIndicator.text = turnPattern.indicatorText
        patternIndicator.fontSize = size.width * 0.4
        patternIndicator.fontColor = .black
        patternIndicator.position = CGPoint(x: 0, y: 0) // Центрируем индикатор
        patternIndicator.verticalAlignmentMode = .center
        patternIndicator.horizontalAlignmentMode = .center
        
        super.init()
        
        // Добавляем спрайт и индикатор
        addChild(shipSprite)
        addChild(patternIndicator)
        
        // Устанавливаем начальный угол поворота
        zRotation = direction.angle
        
        // Запускаем анимацию пульсации для неактивного состояния
        startPulseAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Настройка физического тела
    
    func setupPhysicsBody(radius: CGFloat, categoryBitMask: UInt32) {
        // Создаем круглое физическое тело
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic = true
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = categoryBitMask // Проверяем контакт с другими кораблями
        physicsBody?.collisionBitMask = 0 // Отключаем физическую коллизию
    }
    
    // MARK: - Обработчик нажатия
    
    func setupTapHandler(handler: @escaping () -> Void) {
        // Сохраняем замыкание-обработчик
        self.tapHandler = handler
        
        // Включаем обработку касаний непосредственно в узле
        isUserInteractionEnabled = true
    }
    
    private var tapHandler: (() -> Void)?
    
    // Переопределяем метод обработки касаний SKNode
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isMoving {
            // Останавливаем анимацию пульсации
            stopPulseAnimation()
            
            // Вызываем обработчик нажатия
            tapHandler?()
        }
    }
    
    // MARK: - Анимации
    
    private func startPulseAnimation() {
        // Создаем последовательность действий для пульсации
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let pulse = SKAction.repeatForever(sequence)
        
        // Запускаем анимацию
        shipSprite.run(pulse, withKey: "pulseAnimation")
    }
    
    private func stopPulseAnimation() {
        // Останавливаем анимацию пульсации
        shipSprite.removeAction(forKey: "pulseAnimation")
        shipSprite.setScale(1.0)
    }
    
    // MARK: - Вспомогательные методы
}

// MARK: - Расширения

extension TurnPattern {
    /// Текстовое представление для отображения на индикаторе
    var indicatorText: String {
        switch self {
        case .straight: return "S"
        case .left: return "L"
        case .right: return "R"
        }
    }
}
