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
    
    // Отладочная метка
    var debugLabel: SKLabelNode?
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Сохраняем размеры экрана
        screenSize = size
        
        // Добавляем отладочную метку
        setupDebugLabel()
        
        // Расчитываем размеры элементов
        calculateSizes()
        
        // Настраиваем сцену
        setupScene()
        
        // Запускаем игру
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isGameRunning = true
            self.updateDebugLabel("Найдите правильную последовательность запуска кораблей")
        }
    }
    
    // MARK: - Debug
    
    private func setupDebugLabel() {
        debugLabel = SKLabelNode(fontNamed: "Arial")
        debugLabel?.fontSize = 14
        debugLabel?.fontColor = .white
        debugLabel?.position = CGPoint(x: size.width/2, y: size.height - 30)
        debugLabel?.zPosition = 100
        debugLabel?.text = "Инициализация..."
        debugLabel?.horizontalAlignmentMode = .center
        
        if let debugLabel = debugLabel {
            addChild(debugLabel)
        }
    }
    
    private func updateDebugLabel(_ text: String) {
        debugLabel?.text = text
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
        // Настройка фона - вода
        setupWaterBackground()
        
        // Создание доков (пирсов)
        setupDocks()
        
        // Добавляем UI элементы (кнопки, счет)
        setupUI()
        
        // Создание кораблей для текущего уровня
        setupShips()
        
        // Добавляем номер уровня
        setupLevelLabel()
    }
    
    private func setupWaterBackground() {
        // Создаем голубой фон с эффектом волн
        backgroundColor = SKColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        
        // Добавляем текстуру воды (для визуального эффекта, как на скриншоте)
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
        // Создаем визуальное представление пирса как на скриншоте
        let dock = SKShapeNode(rectOf: dockSize, cornerRadius: 10)
        dock.fillColor = .gray
        dock.strokeColor = .lightGray
        dock.lineWidth = 4
        dock.position = position
        dock.zPosition = 5
        dock.name = "dock"
        
        addChild(dock)
    }
    
    private func setupUI() {
        // Добавляем панель счета (как на скриншоте)
        let scorePanel = SKSpriteNode(color: .orange, size: CGSize(width: 140, height: 45))
        scorePanel.position = CGPoint(x: screenSize.width / 2, y: screenSize.height - 60)
        scorePanel.zPosition = 50
        addChild(scorePanel)
        
        // Текст "SCORE"
        let scoreLabel = SKLabelNode(fontNamed: "Arial-Bold")
        scoreLabel.text = "SCORE"
        scoreLabel.fontSize = 22
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: 0, y: 5)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        scorePanel.addChild(scoreLabel)
        
        // Поле для счета
        let scoreField = SKShapeNode(rectOf: CGSize(width: 120, height: 25), cornerRadius: 5)
        scoreField.fillColor = .white
        scoreField.strokeColor = .orange
        scoreField.lineWidth = 2
        scoreField.position = CGPoint(x: 0, y: -12)
        scorePanel.addChild(scoreField)
        
        // Кнопка назад (как на скриншоте)
        let backButton = SKShapeNode(rectOf: CGSize(width: 60, height: 50), cornerRadius: 8)
        backButton.fillColor = .orange
        backButton.strokeColor = .white
        backButton.lineWidth = 3
        backButton.position = CGPoint(x: 50, y: screenSize.height - 50)
        backButton.zPosition = 50
        backButton.name = "backButton"
        addChild(backButton)
        
        // Стрелка для кнопки назад
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: -10, y: 0))
        arrowPath.addLine(to: CGPoint(x: 10, y: 15))
        arrowPath.addLine(to: CGPoint(x: 10, y: -15))
        arrowPath.close()
        
        let arrow = SKShapeNode(path: arrowPath.cgPath)
        arrow.fillColor = .white
        arrow.strokeColor = .white
        arrow.position = CGPoint(x: -5, y: 0)
        backButton.addChild(arrow)
        
        // Кнопка перезапуска (как на скриншоте)
        let restartButton = SKShapeNode(circleOfRadius: 25)
        restartButton.fillColor = .orange
        restartButton.strokeColor = .white
        restartButton.lineWidth = 3
        restartButton.position = CGPoint(x: screenSize.width - 50, y: screenSize.height - 50)
        restartButton.zPosition = 50
        restartButton.name = "restartButton"
        addChild(restartButton)
        
        // Значок перезапуска
        let restartIcon = SKShapeNode()
        let refreshPath = UIBezierPath()
        refreshPath.addArc(
            withCenter: CGPoint.zero,
            radius: 10,
            startAngle: .pi / 4,
            endAngle: 2 * .pi - .pi / 4,
            clockwise: true
        )
        refreshPath.addLine(to: CGPoint(x: 5, y: -15))
        refreshPath.addLine(to: CGPoint(x: -5, y: -10))
        refreshPath.addLine(to: CGPoint(x: 0, y: -5))
        
        restartIcon.path = refreshPath.cgPath
        restartIcon.strokeColor = .white
        restartIcon.lineWidth = 2
        restartButton.addChild(restartIcon)
    }
    
    private func setupShips() {
        // Очищаем существующие корабли
        shipNodes.values.forEach { $0.removeFromParent() }
        shipNodes.removeAll()
        
        // Координаты центров водных путей
        let horizontalPathY = screenSize.height / 2
        let verticalPathX = screenSize.width / 2
        
        // Позиции кораблей (точно как на скриншоте)
        let topShipPosition = CGPoint(x: verticalPathX, y: horizontalPathY - dockSize.height/2 - pathWidth)
        let rightShipPosition = CGPoint(x: verticalPathX + dockSize.width/2 + pathWidth, y: horizontalPathY)
        let bottomShipPosition = CGPoint(x: verticalPathX, y: horizontalPathY + dockSize.height/2 + pathWidth)
        let leftShipPosition = CGPoint(x: verticalPathX - dockSize.width/2 - pathWidth, y: horizontalPathY)
        
        // Уровень 1 - как на скриншоте
        // Каждый корабль создается с правильным поворотом и буквой
        
        // Верхний корабль - смотрит вниз, поворот налево
        createShip(at: topShipPosition, rotation: .pi/2, turnPattern: .left, color: .systemBlue)
        
        // Правый корабль - смотрит влево, поворот налево
        createShip(at: rightShipPosition, rotation: .pi, turnPattern: .left, color: .systemBlue)
        
        // Нижний корабль - смотрит вверх, поворот направо
        createShip(at: bottomShipPosition, rotation: -.pi/2, turnPattern: .right, color: .systemBlue)
        
        // Левый корабль - смотрит вправо, поворот направо
        createShip(at: leftShipPosition, rotation: 0, turnPattern: .right, color: .systemBlue)
        
        updateDebugLabel("Нажмите на корабль, чтобы начать")
    }

    private func createShip(at position: CGPoint, rotation: CGFloat, turnPattern: TurnDirection, color: UIColor) {
        // Создаем узел для корабля
        let shipNode = SKSpriteNode(color: .clear, size: CGSize(width: pathWidth * 1.2, height: pathWidth * 1.8))
        shipNode.position = position
        shipNode.zRotation = rotation
        shipNode.zPosition = 10
        shipNode.name = "ship"
        
        // Создаем треугольную форму корабля
        let shipShape = SKShapeNode()
        let shipPath = UIBezierPath()
        
        // Рисуем простой треугольник для корабля
        shipPath.move(to: CGPoint(x: 0, y: -shipNode.size.height/2)) // Нос
        shipPath.addLine(to: CGPoint(x: shipNode.size.width/2, y: shipNode.size.height/2)) // Правый борт
        shipPath.addLine(to: CGPoint(x: -shipNode.size.width/2, y: shipNode.size.height/2)) // Левый борт
        shipPath.close()
        
        shipShape.path = shipPath.cgPath
        shipShape.fillColor = color
        shipShape.strokeColor = .white
        shipShape.lineWidth = 2
        shipNode.addChild(shipShape)
        
        // Добавляем буквенное обозначение паттерна поворота
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        
        // Присваиваем букву в зависимости от паттерна (как на скриншоте)
        switch turnPattern {
        case .left:
            // На скриншоте для поворота налево используется буква "Г" или "L"
            if rotation == .pi/2 || rotation == .pi {
                // Для верхнего и правого кораблей
                label.text = "Г"
            } else {
                label.text = "L"
            }
        case .right:
            label.text = "R"
        case .straight:
            label.text = "S"
        case .reverse:
            label.text = "U"
        }
        
        label.fontSize = 30
        label.fontColor = .black
        label.position = CGPoint(x: 0, y: 0)
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = 11
        label.name = "pattern_label"
        
        shipNode.addChild(label)
        
        // Сохраняем информацию о корабле
        let shipId = UUID()
        shipNode.userData = NSMutableDictionary()
        shipNode.userData?.setValue(shipId.uuidString, forKey: "id")
        shipNode.userData?.setValue(turnPattern.rawValue, forKey: "turnPattern")
        shipNode.userData?.setValue(false, forKey: "isMoving")
        shipNode.userData?.setValue(0, forKey: "intersectionsPassed")
        
        addChild(shipNode)
        shipNodes[shipId] = shipNode
        
        // Добавляем индикацию, что корабль интерактивен
        let pulseAction = SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.5),
            SKAction.scale(to: 1.0, duration: 0.5)
        ])
        let repeatPulse = SKAction.repeatForever(pulseAction)
        shipNode.run(repeatPulse)
    }
    
    private func setupLevelLabel() {
        // Добавляем метку с номером уровня (как на скриншоте)
        let levelLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        levelLabel.text = "LVL \(viewModel?.currentLevel?.id ?? 1)"
        levelLabel.fontSize = 30
        levelLabel.fontColor = .yellow
        levelLabel.position = CGPoint(x: screenSize.width / 2, y: 30)
        levelLabel.zPosition = 5
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.verticalAlignmentMode = .center
        
        // Добавляем тень для лучшей видимости
        levelLabel.attributedText = NSAttributedString(
            string: levelLabel.text ?? "",
            attributes: [
                NSAttributedString.Key.strokeColor: UIColor.darkGray,
                NSAttributedString.Key.strokeWidth: -3.0,
                NSAttributedString.Key.foregroundColor: UIColor.yellow
            ]
        )
        
        addChild(levelLabel)
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let nodes = nodes(at: location)
        
        for node in nodes {
            // Обработка нажатия на кнопку "назад"
            if node.name == "backButton" {
                viewModel?.goToMenu()
                return
            }
            
            // Обработка нажатия на кнопку "перезапуск"
            if node.name == "restartButton" {
                resetScene()
                viewModel?.resetGameState()
                return
            }
            
            // Обработка нажатия на корабль
            if isGameRunning && (node.name == "ship" || node.parent?.name == "ship") {
                let shipNode = node.name == "ship" ? node as? SKSpriteNode : node.parent as? SKSpriteNode
                
                if let shipNode = shipNode,
                   let isMovingValue = shipNode.userData?.value(forKey: "isMoving") as? Bool,
                   !isMovingValue {
                    startShipMovement(shipNode)
                    return
                }
            }
        }
    }
    
    private func startShipMovement(_ shipNode: SKSpriteNode) {
        updateDebugLabel("Корабль начал движение!")
        
        // Помечаем корабль как движущийся
        shipNode.userData?.setValue(true, forKey: "isMoving")
        
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
            if let intersectionsPassed = shipNode.userData?.value(forKey: "intersectionsPassed") as? Int,
               intersectionsPassed == 0 {
                // Отмечаем, что корабль прошел перекресток
                shipNode.userData?.setValue(1, forKey: "intersectionsPassed")
                
                // Применяем поворот на перекрестке
                handleIntersection(shipNode)
            }
        }
        
        // Проверка столкновения с другими кораблями
        for (id, otherShip) in shipNodes {
            // Пропускаем проверку с самим собой
            guard otherShip != shipNode,
                  let otherIsMoving = otherShip.userData?.value(forKey: "isMoving") as? Bool,
                  otherIsMoving == true else { continue }
            
            // Вычисляем расстояние между кораблями
            let distance = hypot(
                shipNode.position.x - otherShip.position.x,
                shipNode.position.y - otherShip.position.y
            )
            
            // Если корабли столкнулись
            if distance < (shipNode.size.width + otherShip.size.width) / 3 {
                handleCollision(shipNode, otherShipNode: otherShip)
                return
            }
        }
    }
    
    private func handleIntersection(_ shipNode: SKSpriteNode) {
        // Получаем паттерн поворота
        if let turnPatternValue = shipNode.userData?.value(forKey: "turnPattern") as? String,
           let turnPattern = TurnDirection(rawValue: turnPatternValue) {
            
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
    }
    
    private func handleCollision(_ shipNode: SKSpriteNode, otherShipNode: SKSpriteNode) {
        // Останавливаем движение обоих кораблей
        shipNode.removeAllActions()
        otherShipNode.removeAllActions()
        
        // Анимация столкновения
        let redColorAction = SKAction.colorize(with: .red, colorBlendFactor: 0.8, duration: 0.2)
        shipNode.run(redColorAction)
        otherShipNode.run(redColorAction)
        
        // Эффект взрыва
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        explosion?.position = CGPoint(
            x: (shipNode.position.x + otherShipNode.position.x) / 2,
            y: (shipNode.position.y + otherShipNode.position.y) / 2
        )
        explosion?.zPosition = 20
        addChild(explosion!)
        
        // Останавливаем игру
        isGameRunning = false
        
        // Уведомляем ViewModel о столкновении
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel?.shipCollision()
        }
    }
    
    private func shipExitedGrid(_ shipNode: SKSpriteNode) {
        // Останавливаем все действия
        shipNode.removeAllActions()
        
        // Удаляем корабль из сцены
        if let shipId = shipNode.userData?.value(forKey: "id") as? String,
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
        
        updateDebugLabel("Уровень пройден!")
        
        // Создаем эффект завершения уровня
        let victoryLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        victoryLabel.text = "УРОВЕНЬ ПРОЙДЕН!"
        victoryLabel.fontSize = 40
        victoryLabel.fontColor = .green
        victoryLabel.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        victoryLabel.zPosition = 100
        victoryLabel.horizontalAlignmentMode = .center
        victoryLabel.alpha = 0
        
        addChild(victoryLabel)
        
        // Анимация появления
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.5)
        
        victoryLabel.run(SKAction.sequence([
            SKAction.group([fadeIn, scaleUp]),
            wait
        ])) { [weak self] in
            // Уведомляем ViewModel о завершении уровня
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
        setupDebugLabel()
        setupScene()
        
        // Запускаем игру после короткой задержки
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isGameRunning = true
            self.updateDebugLabel("Игра перезапущена. Найдите правильную последовательность запуска кораблей!")
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
