import SpriteKit
import UIKit

class ShipNode: SKNode {
    // MARK: - Свойства
    
    /// Идентификатор корабля
    let id: UUID
    
    /// Направление движения корабля
    var direction: ShipDirection {
        didSet {
            // При изменении направления обновляем ориентацию корабля
            updateOrientation()
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

        // Загружаем текстуру корабля
        let shipTexture = SKTexture(imageNamed: "ship")
        shipSprite = SKSpriteNode(texture: shipTexture)
        
        // Задаем новые размеры: shipWidth и shipHeight
        let shipWidth = size.width * 0.8
        let shipHeight = size.height * 2
        shipSprite.size = CGSize(width: shipWidth, height: shipHeight)
        
        // Создаем индикатор паттерна поворота (оставляем без изменений)
        patternIndicator = SKLabelNode(fontNamed: "Helvetica-Bold")
        patternIndicator.text = turnPattern.indicatorText
        patternIndicator.fontSize = shipWidth * 0.4
        patternIndicator.fontColor = .black
        patternIndicator.position = CGPoint(x: 0, y: 0)
        patternIndicator.verticalAlignmentMode = .center
        patternIndicator.horizontalAlignmentMode = .center

        super.init()

        // Добавляем спрайт и индикатор
        addChild(shipSprite)
        addChild(patternIndicator)

        startPulseAnimation()
        updateOrientation(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Поворот корабля
    
    /// Обновляет ориентацию корабля в соответствии с направлением движения
    private func updateOrientation(animated: Bool = true) {
        let duration: TimeInterval = isMoving && animated ? 0.2 : 0.0

        // Определяем правильный угол поворота
        let angle: CGFloat
        switch direction {
        case .north:
            angle = 0                // 0 градусов (смотрит вверх)
        case .south:
            angle = CGFloat.pi       // 180 градусов (смотрит вниз)
        case .east:
            angle = -CGFloat.pi / 2   // 90 градусов (смотрит вправо)
        case .west:
            angle = CGFloat.pi / 2  // -90 градусов (смотрит влево)
        }

        // Поворачиваем весь узел, чтобы все дочерние элементы (shipSprite и patternIndicator) меняли ориентацию
        if animated {
            let rotateAction = SKAction.rotate(toAngle: angle, duration: duration, shortestUnitArc: true)
            self.run(rotateAction)
        } else {
            self.zRotation = angle
        }
    }
    
    /// Применяет правильный поворот в зависимости от направления
    func applyCorrectRotation(animated: Bool = true) {
        updateOrientation(animated: animated)
    }
    
    // MARK: - Настройка физического тела
    
    func setupPhysicsBody(radius: CGFloat, categoryBitMask: UInt32) {
        // Создаем круглое физическое тело
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.isDynamic = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = categoryBitMask
        physicsBody?.collisionBitMask = 0
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
        let scaleUp = SKAction.scale(to: 1.05, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.95, duration: 0.5)
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
