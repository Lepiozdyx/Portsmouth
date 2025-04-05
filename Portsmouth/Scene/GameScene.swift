import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    // Количество пирсов и водных путей
    let dockRows = 2
    let dockColumns = 2
    
    // Ссылка на ViewModel
    weak var viewModel: GameViewModel?
    
    // Размеры экрана и элементов
    var screenSize: CGSize = .zero
    var dockSize: CGSize = .zero
    var pathWidth: CGFloat = 0
    var intersectionSize: CGFloat = 0
    
    // Корабли на сцене
    var shipNodes: [UUID: SKSpriteNode] = [:]
    
    // Флаг, показывающий, что игра запущена
    var isGameRunning = false
    
    // Количество кораблей, успешно достигших выхода
    var shipsReachedExit = 0
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Сохраняем размеры экрана
        screenSize = size
        
        // Расчитываем размеры элементов
        calculateSizes()
        
        // Настраиваем сцену
        setupScene()
        
        // Запускаем игру
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isGameRunning = true
        }
    }
    
    // MARK: - Setup
    
    private func calculateSizes() {
        // Размеры пирса - как на скриншоте, примерно 40% ширины и 30% высоты экрана
        let dockWidth = screenSize.width * 0.4
        let dockHeight = screenSize.height * 0.3
        dockSize = CGSize(width: dockWidth, height: dockHeight)
        
        // Ширина водного пути - примерно 10% ширины экрана
        pathWidth = screenSize.width * 0.1
        
        // Размер перекрестка
        intersectionSize = pathWidth * 0.7
    }
    
    private func setupScene() {
        setupWaterBackground()
        setupDocks()
        setupShips()
    }
    
    private func setupWaterBackground() {
        // Создаем голубой фон с эффектом волн
        backgroundColor = SKColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        
        // Добавляем текстуру воды (для визуального эффекта)
        for i in 0..<3 {
            for j in 0..<4 {
                let waterPattern = SKSpriteNode(color: .clear, size: CGSize(width: size.width / 3, height: size.height / 4))
                waterPattern.position = CGPoint(
                    x: CGFloat(i) * size.width / 3 + size.width / 6,
                    y: CGFloat(j) * size.height / 4 + size.height / 8
                )
                waterPattern.zPosition = -1
                
                // Создаем эффект волн
                let path = UIBezierPath()
                for x in stride(from: 0, to: Int(waterPattern.size.width), by: 20) {
                    for y in stride(from: 0, to: Int(waterPattern.size.height), by: 20) {
                        let startX = CGFloat(x) - waterPattern.size.width / 2
                        let startY = CGFloat(y) - waterPattern.size.height / 2
                        
                        path.move(to: CGPoint(x: startX, y: startY))
                        path.addCurve(
                            to: CGPoint(x: startX + 20, y: startY + 5),
                            controlPoint1: CGPoint(x: startX + 5, y: startY - 5),
                            controlPoint2: CGPoint(x: startX + 15, y: startY + 10)
                        )
                    }
                }
                
                let waveShape = SKShapeNode(path: path.cgPath)
                waveShape.strokeColor = SKColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 0.3)
                waveShape.lineWidth = 2
                waterPattern.addChild(waveShape)
                
                addChild(waterPattern)
            }
        }
    }
    
    private func setupDocks() {
        let horizontalPadding = (screenSize.width - (dockSize.width * CGFloat(dockColumns) + pathWidth)) / 2
        let verticalPadding = (screenSize.height - (dockSize.height * CGFloat(dockRows) + pathWidth)) / 2
        
        // Создаем 4 пирса в углах экрана
        for row in 0..<dockRows {
            for col in 0..<dockColumns {
                // Вычисляем позицию для дока
                let xPos: CGFloat
                if col == 0 {
                    xPos = horizontalPadding + dockSize.width / 2
                } else {
                    xPos = screenSize.width - horizontalPadding - dockSize.width / 2
                }
                
                let yPos: CGFloat
                if row == 0 {
                    yPos = verticalPadding + dockSize.height / 2
                } else {
                    yPos = screenSize.height - verticalPadding - dockSize.height / 2
                }
                
                // Создаем пирс
                createDock(at: CGPoint(x: xPos, y: yPos))
            }
        }
    }
    

    
    private func createDock(at position: CGPoint) {
        let dock = SKShapeNode(rectOf: dockSize, cornerRadius: 10)
        dock.fillColor = .gray
        dock.strokeColor = .lightGray
        dock.lineWidth = 4
        dock.position = position
        dock.zPosition = 5
        dock.name = "dock"
        
        addChild(dock)
    }
    
    private func setupShips() {
        // Очищаем существующие корабли
        shipNodes.values.forEach { $0.removeFromParent() }
        shipNodes.removeAll()
        
        // Координаты центров водных путей
        let horizontalPathY = screenSize.height / 2
        let verticalPathX = screenSize.width / 2
        
        // Позиции кораблей
        let topShipPosition = CGPoint(x: verticalPathX, y: horizontalPathY - dockSize.height/2 - pathWidth)
        let rightShipPosition = CGPoint(x: verticalPathX + dockSize.width/2 + pathWidth, y: horizontalPathY)
        let bottomShipPosition = CGPoint(x: verticalPathX, y: horizontalPathY + dockSize.height/2 + pathWidth)
        let leftShipPosition = CGPoint(x: verticalPathX - dockSize.width/2 - pathWidth, y: horizontalPathY)
        
        // Верхний корабль - смотрит вниз (к центру), поворот налево
        createShip(at: topShipPosition, rotation: .pi/2, turnPattern: .left, color: .systemBlue)
        
        // Правый корабль - смотрит ВПРАВО (от центра), движется прямо
        createShip(at: rightShipPosition, rotation: 0, turnPattern: .straight, color: .systemGreen)
        
        // Нижний корабль - смотрит вверх (к центру), поворот направо
        createShip(at: bottomShipPosition, rotation: -.pi/2, turnPattern: .right, color: .systemRed)
        
        // Левый корабль - смотрит вправо (к центру), поворот направо
        createShip(at: leftShipPosition, rotation: 0, turnPattern: .right, color: .systemOrange)
    }

    private func createShip(
        at position: CGPoint,
        rotation: CGFloat,
        turnPattern: TurnDirection,
        color: UIColor
    ) {
        // 1. Создаём контейнерный узел
        let shipNode = SKSpriteNode(
            color: .clear,
            size: CGSize(width: pathWidth * 0.8, height: pathWidth * 1.4)
        )
        shipNode.position = position
        shipNode.zRotation = rotation
        shipNode.zPosition = 10
        shipNode.name = "ship"

        // 2. Строим треугольник: нос → вправо
        let shipShape = SKShapeNode()
        let halfW = shipNode.size.width  / 2
        let halfH = shipNode.size.height / 2
        let shipPath = UIBezierPath()
        shipPath.move(to: CGPoint(x:  halfW, y:  0))      // нос
        shipPath.addLine(to: CGPoint(x: -halfW, y:  halfH)) // правая задняя точка
        shipPath.addLine(to: CGPoint(x: -halfW, y: -halfH)) // левая задняя точка
        shipPath.close()
        shipShape.path = shipPath.cgPath
        shipShape.fillColor = color
        shipShape.strokeColor = .white
        shipShape.lineWidth = 2
        shipNode.addChild(shipShape)

        // 3. Добавляем букву паттерна поворота
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        switch turnPattern {
        case .left:
            label.text = "L"
        case .right:
            label.text = "R"
        case .straight:
            label.text = "S"
        case .reverse:
            label.text = "U"
        }
        label.fontSize = 24
        label.fontColor = .white
        label.position = .zero
        label.zPosition = 11
        shipNode.addChild(label)

        // 4. Сохраняем данные и добавляем интерактивность
        let shipId = UUID()
        shipNode.userData = NSMutableDictionary(dictionary: [
            "id": shipId.uuidString,
            "turnPattern": turnPattern.rawValue,
            "isMoving": false,
            "intersectionsPassed": 0
        ])
        addChild(shipNode)
        shipNodes[shipId] = shipNode

        let pulse = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ])
        shipNode.run(.repeatForever(pulse))
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        for node in nodes {
            // Обработка нажатия на корабль
            if isGameRunning && (node.name == "ship" || node.parent?.name == "ship") {
                let shipNode = node.name == "ship" ? node as? SKSpriteNode : node.parent as? SKSpriteNode
                
                if let shipNode = shipNode,
                   let userData = shipNode.userData as? NSMutableDictionary,
                   let isMovingValue = userData["isMoving"] as? Bool,
                   !isMovingValue {
                    startShipMovement(shipNode)
                    return
                }
            }
        }
    }
    
    private func startShipMovement(_ shipNode: SKSpriteNode) {
        // Помечаем корабль как движущийся
        if let userData = shipNode.userData as? NSMutableDictionary {
            userData["isMoving"] = true
        }
        
        // Останавливаем анимацию пульсации
        shipNode.removeAllActions()
        
        // Определяем направление движения по ротации
        let direction = getDirectionFromRotation(shipNode.zRotation)
        
        // Начинаем движение
        moveShip(shipNode, direction: direction)
    }
    
    private func getDirectionFromRotation(_ rotation: CGFloat) -> CGVector {
        // Определяем вектор движения по углу поворота
        let normalizedRotation = normalizeAngle(rotation)
        
        // Корабль всегда движется вперед носом
        return CGVector(
            dx: cos(normalizedRotation),
            dy: sin(normalizedRotation)
        )
    }
    
    private func normalizeAngle(_ angle: CGFloat) -> CGFloat {
        // Нормализуем угол до диапазона [0, 2π)
        return (angle.truncatingRemainder(dividingBy: 2 * .pi) + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi)
    }
    
    private func moveShip(_ shipNode: SKSpriteNode, direction: CGVector) {
        // Скорость движения корабля
        let speed: CGFloat = 100
        
        // Применяем физику для прямолинейного движения
        let dx = direction.dx * speed
        let dy = direction.dy * speed
        
        // Создаем действие для движения вперед
        let moveAction = SKAction.moveBy(x: dx, y: dy, duration: 1.0)
        let repeatMove = SKAction.repeatForever(moveAction)
        
        // Запускаем движение
        shipNode.run(SKAction.sequence([
            // Небольшая задержка для визуального эффекта
            SKAction.wait(forDuration: 0.1),
            // Бесконечное движение вперед
            repeatMove
        ]), withKey: "movement")
        
        // Запускаем проверку на пересечение перекрестка и границы
        let checkAction = SKAction.run { [weak self] in
            self?.checkShipPosition(shipNode)
        }
        let wait = SKAction.wait(forDuration: 0.1)
        let checkSequence = SKAction.sequence([wait, checkAction])
        let repeatCheck = SKAction.repeatForever(checkSequence)
        
        shipNode.run(repeatCheck, withKey: "positionCheck")
    }
    
    private func checkShipPosition(_ shipNode: SKSpriteNode) {
        // Проверка выхода за границы экрана
        if shipNode.position.x < -shipNode.size.width ||
           shipNode.position.x > screenSize.width + shipNode.size.width ||
           shipNode.position.y < -shipNode.size.height ||
           shipNode.position.y > screenSize.height + shipNode.size.height {
            // Корабль успешно вышел
            shipExitedGrid(shipNode)
            return
        }
        
        // Проверка достижения перекрестка (центра экрана)
        let intersectionPoint = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        let distance = hypot(
            shipNode.position.x - intersectionPoint.x,
            shipNode.position.y - intersectionPoint.y
        )
        
        // Если корабль достиг перекрестка (с некоторой погрешностью)
        if distance < intersectionSize / 2 {
            // Проверяем, проходил ли уже корабль перекресток
            if let userData = shipNode.userData as? NSMutableDictionary,
               let intersectionsPassed = userData["intersectionsPassed"] as? Int,
               intersectionsPassed == 0 {
                // Отмечаем, что корабль прошел перекресток
                userData["intersectionsPassed"] = 1
                
                // Применяем поворот на перекрестке
                handleIntersection(shipNode)
            }
        }
        
        // Проверка столкновения с другими кораблями
        for (_, otherShip) in shipNodes {
            // пропускаем себя
            guard otherShip != shipNode else { continue }
            
            // вычисляем расстояние между центрами
            let dx = shipNode.position.x - otherShip.position.x
            let dy = shipNode.position.y - otherShip.position.y
            let distance = hypot(dx, dy)
            
            // порог столкновения — половина суммы ширин кораблей
            let collisionThreshold = (shipNode.size.width + otherShip.size.width) * 0.4
            
            if distance < collisionThreshold {
                handleCollision(shipNode, otherShipNode: otherShip)
                return
            }
        }
    }
    
    private func handleIntersection(_ shipNode: SKSpriteNode) {
        // Получаем паттерн поворота
        guard let userData = shipNode.userData as? NSMutableDictionary,
              let turnPatternValue = userData["turnPattern"] as? String,
              let turnPattern = TurnDirection(rawValue: turnPatternValue) else {
            return
        }
        
        // Останавливаем движение
        shipNode.removeAction(forKey: "movement")
        
        // Определяем угол поворота в зависимости от паттерна
        var rotationDelta: CGFloat = 0
        
        switch turnPattern {
        case .left:
            rotationDelta = .pi/2 // поворот налево на 90°
        case .right:
            rotationDelta = -.pi/2 // поворот направо на 90°
        case .reverse:
            rotationDelta = .pi // разворот на 180°
        case .straight:
            rotationDelta = 0 // продолжение движения прямо
        }
        
        // Применяем поворот, если нужен
        if rotationDelta != 0 {
            let newRotation = shipNode.zRotation + rotationDelta
            let rotateAction = SKAction.rotate(toAngle: newRotation, duration: 0.3)
            
            shipNode.run(rotateAction) { [weak self] in
                // После поворота продолжаем движение в новом направлении
                if let self = self {
                    let newDirection = self.getDirectionFromRotation(shipNode.zRotation)
                    self.moveShip(shipNode, direction: newDirection)
                }
            }
        } else {
            // Если нет поворота, просто продолжаем движение
            let direction = getDirectionFromRotation(shipNode.zRotation)
            moveShip(shipNode, direction: direction)
        }
    }
    
    private func handleCollision(_ shipNode: SKSpriteNode, otherShipNode: SKSpriteNode) {
        // Проверяем, не находимся ли мы уже в состоянии столкновения
        guard isGameRunning else { return }
        
        // Останавливаем игру
        isGameRunning = false
        
        // Останавливаем движение всех кораблей
        for (_, ship) in shipNodes {
            ship.removeAllActions()
        }
        
        // Анимация столкновения
        let explosion = SKEmitterNode(fileNamed: "Explosion") ?? createExplosionEmitter()
        explosion.position = CGPoint(
            x: (shipNode.position.x + otherShipNode.position.x) / 2,
            y: (shipNode.position.y + otherShipNode.position.y) / 2
        )
        explosion.zPosition = 20
        addChild(explosion)
        
        // Визуальный эффект столкновения
        let redColorAction = SKAction.colorize(with: .red, colorBlendFactor: 0.8, duration: 0.2)
        shipNode.run(redColorAction)
        otherShipNode.run(redColorAction)
        
        // Уведомляем ViewModel о столкновении после небольшой задержки
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewModel?.shipCollision()
        }
    }
    
    private func createExplosionEmitter() -> SKEmitterNode {
        // Создаем эмиттер вручную, если файл не найден
        let explosion = SKEmitterNode()
        explosion.particleTexture = SKTexture(imageNamed: "spark")
        explosion.particleBirthRate = 500
        explosion.numParticlesToEmit = 50
        explosion.particleLifetime = 2.0
        explosion.emissionAngle = 0
        explosion.emissionAngleRange = 2 * .pi
        explosion.particleSpeed = 50
        explosion.particleSpeedRange = 50
        explosion.particleAlpha = 1.0
        explosion.particleAlphaRange = 0.0
        explosion.particleAlphaSpeed = -0.5
        explosion.particleScale = 0.5
        explosion.particleScaleRange = 0.25
        explosion.particleScaleSpeed = -0.25
        explosion.particleColor = .orange
        explosion.particleColorBlendFactor = 1.0
        explosion.particleColorBlendFactorRange = 0.3
        explosion.particleColorBlendFactorSpeed = -0.5
        explosion.particleColorSequence = SKKeyframeSequence(keyframeValues: [
            UIColor.red,
            UIColor.orange,
            UIColor.yellow,
            UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.0)
        ], times: [0.0, 0.1, 0.3, 1.0])
        return explosion
    }
    
    private func shipExitedGrid(_ shipNode: SKSpriteNode) {
        // Останавливаем все действия
        shipNode.removeAllActions()
        
        // Удаляем корабль из сцены
        if let userData = shipNode.userData as? NSMutableDictionary,
           let shipId = userData["id"] as? String,
           let uuid = UUID(uuidString: shipId) {
            shipNodes.removeValue(forKey: uuid)
        }
        shipNode.removeFromParent()
        
        // Увеличиваем счетчик
        shipsReachedExit += 1
        
        // Уведомляем ViewModel об успешном выходе
        viewModel?.shipReachedExit()
        
        // Проверяем, все ли корабли вышли
        if shipNodes.isEmpty {
            levelCompleted()
        }
    }
    
    private func levelCompleted() {
        // Останавливаем игру
        isGameRunning = false
        
        // Уведомляем ViewModel о завершении уровня
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.viewModel?.completeLevel()
        }
    }
    
    // MARK: - Public Methods
    
    func resetScene() {
        // Удаляем все дочерние узлы
        removeAllChildren()
        
        // Сбрасываем состояние
        isGameRunning = false
        shipsReachedExit = 0
        shipNodes.removeAll()
        
        // Настраиваем сцену заново
        setupScene()
        
        // Запускаем игру после короткой задержки
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isGameRunning = true
        }
    }
}

// Расширение для TurnDirection
extension TurnDirection: RawRepresentable {
    public typealias RawValue = String
    
    public init?(rawValue: String) {
        switch rawValue {
        case "left": self = .left
        case "right": self = .right
        case "straight": self = .straight
        case "reverse": self = .reverse
        default: return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .left: return "left"
        case .right: return "right"
        case .straight: return "straight"
        case .reverse: return "reverse"
        }
    }
}
