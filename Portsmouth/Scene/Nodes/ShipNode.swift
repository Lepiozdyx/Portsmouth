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
            applyCorrectRotation()
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
        
        // Запускаем анимацию пульсации для неактивного состояния
        startPulseAnimation()
        
        // ВАЖНО: Применяем начальное вращение только после инициализации
        applyCorrectRotation(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Поворот корабля
    
    /// Применяет правильный поворот в зависимости от направления
    func applyCorrectRotation(animated: Bool = true) {
        let duration: TimeInterval = isMoving && animated ? 0.2 : 0.0
        
        // Рассчитываем правильный угол поворота
        // Исходная текстура направлена вверх (.north)
        let angle = getAngleForDirection(direction)
        
        // Выполняем поворот
        let rotateAction = SKAction.rotate(toAngle: angle, duration: duration, shortestUnitArc: true)
        shipSprite.run(rotateAction)
    }
    
    /// Получает угол поворота для заданного направления
    private func getAngleForDirection(_ direction: ShipDirection) -> CGFloat {
        // Поскольку текстура изначально смотрит вверх (north),
        // для других направлений нужно повернуть:
        switch direction {
        case .north: // Вверх (исходное положение)
            return 0
            
        case .south: // Вниз (180 градусов)
            return .pi
            
        case .east: // Вправо (90 градусов по часовой)
            return .pi / 2
            
        case .west: // Влево (90 градусов против часовой)
            return -.pi / 2
        }
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
