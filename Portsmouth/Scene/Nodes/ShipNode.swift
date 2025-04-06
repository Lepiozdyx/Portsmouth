import SpriteKit
import UIKit

/// Класс, представляющий корабль в игровой сцене
class ShipNode: SKNode {
    // MARK: - Свойства
    
    /// Идентификатор корабля
    let id: UUID
    
    /// Направление движения корабля
    var direction: ShipDirection {
        didSet {
            // При изменении направления обновляем ориентацию корабля
            updateRotation()
        }
    }
    
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
        
        // Создаем спрайт корабля с текстурой "ship"
        let shipTexture = SKTexture(imageNamed: "ship")
        shipSprite = SKSpriteNode(texture: shipTexture)
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
        
        // Поворачиваем узел в соответствии с исходным направлением
        // Важно: делаем это здесь, после добавления дочерних узлов
        updateRotation()
        
        // Запускаем анимацию пульсации для неактивного состояния
        startPulseAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Обновление поворота
    
    /// Обновляет поворот корабля в соответствии с его направлением
    func updateRotation() {
        // ВАЖНО: Анимируем поворот только если корабль уже движется
        let duration: TimeInterval = isMoving ? 0.2 : 0
        
        // Получаем угол в зависимости от направления
        // SpriteKit: угол = 0 соответствует направлению вправо (ось X),
        // поэтому нам нужно скорректировать углы относительно этого
        let angle: CGFloat
        switch direction {
        case .north:
            angle = -.pi / 2    // -90° (вверх)
        case .south:
            angle = .pi / 2     // 90° (вниз)
        case .east:
            angle = 0           // 0° (вправо)
        case .west:
            angle = .pi         // 180° (влево)
        }
        
        // ВАЖНО: Применяем поворот ко всему узлу, а не только к спрайту!
        // Это обеспечит правильную ориентацию как визуально, так и для физики
        let action = SKAction.rotate(toAngle: angle, duration: duration, shortestUnitArc: true)
        run(action)
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
        
        // Запускаем анимацию пульсации только для спрайта
        shipSprite.run(pulse, withKey: "pulseAnimation")
    }
    
    private func stopPulseAnimation() {
        // Останавливаем анимацию пульсации
        shipSprite.removeAction(forKey: "pulseAnimation")
        shipSprite.setScale(1.0)
    }
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
