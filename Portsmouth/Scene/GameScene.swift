import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    // Размер сетки: 11x15 для более точного расположения прохода шириной в 1 клетку
    let gridWidth = 11
    let gridHeight = 15
    
    // Ссылка на ViewModel
    weak var viewModel: GameViewModel?
    
    // Размер ячейки сетки
    var cellSize: CGFloat = 0
    
    // Массив узлов сетки
    var gridNodes: [[SKNode]] = []
    
    // Корабли на сцене
    var shipNodes: [UUID: SKShapeNode] = [:]
    
    // Флаг, показывающий, что игра запущена
    var isGameRunning = false
    
    // Количество кораблей, успешно достигших выхода
    var shipsReachedExit = 0
    
    // Отладочная метка
    var debugLabel: SKLabelNode?
    
    // MARK: - Scene Lifecycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Добавляем отладочную метку
        setupDebugLabel()
        
        // Вычисляем размер ячейки
        calculateCellSize()
        
        // Настраиваем сцену
        setupScene()
        
        // Запускаем игру
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isGameRunning = true
            self.updateDebugLabel("Игра запущена. Нажмите на корабль, чтобы начать движение.")
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
    
    private func calculateCellSize() {
        // Вычисляем размер ячейки
        let maxCellWidth = size.width / CGFloat(gridWidth)
        let maxCellHeight = size.height / CGFloat(gridHeight)
        cellSize = min(maxCellWidth, maxCellHeight)
        
        updateDebugLabel("Размер ячейки: \(cellSize)")
    }
    
    private func setupScene() {
        // Настройка фона
        backgroundColor = SKColor(red: 0.2, green: 0.6, blue: 0.9, alpha: 1.0)
        
        // Создаем сетку
        setupGrid()
        
        // Создание доков (пристаней) с точными проходами
        setupDocks()
        
        // Создание перекрестков
        setupIntersections()
        
        // Создание кораблей
        setupShips()
        
        // Добавляем номер уровня
        setupLevelLabel()
        
        updateDebugLabel("Сцена настроена. Нажмите на корабль, чтобы начать движение!")
    }
    
    private func setupGrid() {
        // Инициализируем массив сетки
        gridNodes = Array(repeating: Array(repeating: SKNode(), count: gridWidth), count: gridHeight)
        
        // Создаем узлы для каждой ячейки сетки
        for row in 0..<gridHeight {
            for col in 0..<gridWidth {
                let node = SKNode()
                node.position = positionForGridCell(row: row, col: col)
                node.name = "cell_\(row)_\(col)"
                addChild(node)
                gridNodes[row][col] = node
                
                // Отображаем границы ячеек для визуализации сетки
                let border = SKShapeNode(rectOf: CGSize(width: cellSize, height: cellSize))
                border.strokeColor = .white
                border.lineWidth = 0.5
                border.alpha = 0.2
                node.addChild(border)
            }
        }
    }
    
    private func setupDocks() {
        // Верхний левый док - оставляем проход справа
        for row in 0..<4 {
            for col in 0..<4 {
                // Пропускаем последнюю колонку для прохода
                if col < 3 {
                    addDockCell(row: row, col: col)
                }
            }
        }
        
        // Верхний правый док - оставляем проход слева
        for row in 0..<4 {
            for col in (gridWidth-4)..<gridWidth {
                // Пропускаем первую колонку для прохода
                if col > gridWidth-4 {
                    addDockCell(row: row, col: col)
                }
            }
        }
        
        // Нижний левый док - оставляем проход справа
        for row in (gridHeight-4)..<gridHeight {
            for col in 0..<4 {
                // Пропускаем последнюю колонку для прохода
                if col < 3 {
                    addDockCell(row: row, col: col)
                }
            }
        }
        
        // Нижний правый док - оставляем проход слева
        for row in (gridHeight-4)..<gridHeight {
            for col in (gridWidth-4)..<gridWidth {
                // Пропускаем первую колонку для прохода
                if col > gridWidth-4 {
                    addDockCell(row: row, col: col)
                }
            }
        }
        
        // Добавляем центральный проход
        let centerCol = gridWidth / 2
        
        // Верхняя часть центрального прохода
        for row in 4..<(gridHeight/2 - 1) {
            for col in (centerCol-1)..<(centerCol+2) {
                if col == centerCol {
                    // Оставляем проход в центре
                    continue
                }
                addDockCell(row: row, col: col)
            }
        }
        
        // Нижняя часть центрального прохода
        for row in (gridHeight/2 + 1)..<(gridHeight-4) {
            for col in (centerCol-1)..<(centerCol+2) {
                if col == centerCol {
                    // Оставляем проход в центре
                    continue
                }
                addDockCell(row: row, col: col)
            }
        }
    }
    
    private func setupIntersections() {
        // Добавляем перекрестки в ключевых точках
        let centerCol = gridWidth / 2
        let centerRow = gridHeight / 2
        
        // Перекресток в центре
        addIntersection(row: centerRow, col: centerCol)
        
        // Перекрестки по горизонтали
        addIntersection(row: centerRow, col: 3) // Левый перекресток
        addIntersection(row: centerRow, col: gridWidth-4) // Правый перекресток
        
        // Перекрестки по вертикали
        addIntersection(row: 4, col: centerCol) // Верхний перекресток
        addIntersection(row: gridHeight-5, col: centerCol) // Нижний перекресток
    }
    
    private func addIntersection(row: Int, col: Int) {
        // Создаем видимый индикатор перекрестка
        let intersectionNode = SKShapeNode(circleOfRadius: cellSize * 0.2)
        intersectionNode.fillColor = .green
        intersectionNode.alpha = 0.3
        intersectionNode.position = positionForGridCell(row: row, col: col)
        intersectionNode.zPosition = 1
        intersectionNode.name = "intersection_\(row)_\(col)"
        addChild(intersectionNode)
        
        // Помечаем ячейку сетки
        let node = gridNodes[row][col]
        node.userData = NSMutableDictionary()
        node.userData?.setValue("intersection", forKey: "type")
    }
    
    private func addDockCell(row: Int, col: Int) {
        let dockCell = SKShapeNode(rectOf: CGSize(width: cellSize * 0.9, height: cellSize * 0.9), cornerRadius: 5)
        dockCell.fillColor = .gray
        dockCell.strokeColor = .lightGray
        dockCell.lineWidth = 2
        dockCell.position = .zero
        dockCell.zPosition = 1
        dockCell.name = "dock"
        
        let node = gridNodes[row][col]
        node.addChild(dockCell)
        node.userData = NSMutableDictionary()
        node.userData?.setValue("dock", forKey: "type")
    }
    
    private func setupShips() {
        // Очищаем существующие корабли
        shipNodes.values.forEach { $0.removeFromParent() }
        shipNodes.removeAll()
        
        // Определяем позиции и направления 4 кораблей
        let centerCol = gridWidth / 2
        let centerRow = gridHeight / 2
        
        // Конфигурации кораблей (зависят от уровня)
        let levelId = viewModel?.currentLevel?.id ?? 1
        
        // Корабли для каждого уровня имеют разную конфигурацию:
        // - Уровень 1: Самый простой с очевидной последовательностью
        // - Уровень 2: Более сложный, требуется анализ возможных столкновений
        // - Уровень 3+: Сложные конфигурации, требующие тщательного анализа
        
        var shipConfigs: [(row: Int, col: Int, direction: TurnDirection)] = []
        
        switch levelId {
        case 1:
            shipConfigs = [
                (centerRow, 3, .right),           // Левый корабль -> движется вправо
                (4, centerCol, .reverse),         // Верхний корабль -> движется вниз
                (centerRow, gridWidth - 4, .left), // Правый корабль -> движется влево
                (gridHeight - 5, centerCol, .straight) // Нижний корабль -> движется вверх
            ]
        case 2:
            shipConfigs = [
                (centerRow, 3, .right),           // Левый корабль -> движется вправо
                (4, centerCol, .straight),        // Верхний корабль -> движется вверх (назад)
                (centerRow, gridWidth - 4, .left), // Правый корабль -> движется влево
                (gridHeight - 5, centerCol, .reverse) // Нижний корабль -> движется вниз (назад)
            ]
        default:
            shipConfigs = [
                (centerRow, 3, .left),            // Левый корабль -> движется влево (назад)
                (4, centerCol, .reverse),         // Верхний корабль -> движется вниз
                (centerRow, gridWidth - 4, .right), // Правый корабль -> движется вправо (назад)
                (gridHeight - 5, centerCol, .straight) // Нижний корабль -> движется вверх
            ]
        }
        
        // Создаем корабли с разными цветами для удобства различения
        let colors: [UIColor] = [.yellow, .orange, .red, .green]
        
        for (index, config) in shipConfigs.enumerated() {
            createShip(
                row: config.row,
                col: config.col,
                turnPattern: config.direction,
                color: colors[index % colors.count]
            )
        }
        
        updateDebugLabel("Создано кораблей: \(shipNodes.count)")
    }
    
    private func createShip(row: Int, col: Int, turnPattern: TurnDirection, color: UIColor = .yellow) {
        let position = positionForGridCell(row: row, col: col)
        
        // Определяем начальную ротацию на основе направления
        var rotation: CGFloat = 0
        switch turnPattern {
        case .left: rotation = .pi // смотрит влево
        case .right: rotation = 0 // смотрит вправо
        case .straight: rotation = -.pi/2 // смотрит вверх
        case .reverse: rotation = .pi/2 // смотрит вниз
        }
        
        // Создаем корабль как простой треугольник для лучшего понимания направления
        let shipSize = cellSize * 0.8
        let shipNode = SKShapeNode()
        
        // Треугольник, указывающий направление движения
        let path = UIBezierPath()
        path.move(to: CGPoint(x: shipSize/2, y: 0)) // нос корабля
        path.addLine(to: CGPoint(x: -shipSize/2, y: shipSize/2)) // левый нижний угол
        path.addLine(to: CGPoint(x: -shipSize/2, y: -shipSize/2)) // левый верхний угол
        path.close()
        
        shipNode.path = path.cgPath
        shipNode.fillColor = color
        shipNode.strokeColor = .black
        shipNode.lineWidth = 2
        shipNode.position = position
        shipNode.zRotation = rotation
        shipNode.zPosition = 10
        shipNode.name = "ship"
        
        // Добавляем текстовый индикатор направления поворота
        addDirectionLabel(to: shipNode, direction: turnPattern)
        
        // Сохраняем информацию о корабле
        let shipId = UUID()
        shipNode.userData = NSMutableDictionary()
        shipNode.userData?.setValue(shipId.uuidString, forKey: "id")
        shipNode.userData?.setValue(turnPattern.rawValue, forKey: "turnPattern")
        shipNode.userData?.setValue(false, forKey: "isMoving")
        shipNode.userData?.setValue(0, forKey: "intersectionsPassed")
        shipNode.userData?.setValue("\(row),\(col)", forKey: "gridPosition")
        
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
    
    private func addDirectionLabel(to shipNode: SKShapeNode, direction: TurnDirection) {
        // Добавляем текстовую метку для индикации паттерна поворота
        let label = SKLabelNode(fontNamed: "Arial-Bold")
        
        switch direction {
        case .left:
            label.text = "L"
        case .right:
            label.text = "R"
        case .straight:
            label.text = "S"
        case .reverse:
            label.text = "U"
        }
        
        label.fontSize = 14
        label.fontColor = .black
        label.position = CGPoint(x: 0, y: 0)
        label.verticalAlignmentMode = .center
        label.horizontalAlignmentMode = .center
        label.zPosition = 11
        label.name = "direction_label"
        
        shipNode.addChild(label)
    }
    
    private func setupLevelLabel() {
        let levelLabel = SKLabelNode(fontNamed: "Chalkduster")
        levelLabel.text = "LVL \(viewModel?.currentLevel?.id ?? 1)"
        levelLabel.fontSize = 30
        levelLabel.fontColor = .yellow
        levelLabel.position = CGPoint(
            x: size.width / 2,
            y: cellSize // Размещаем в нижней части экрана
        )
        levelLabel.zPosition = 5
        levelLabel.horizontalAlignmentMode = .center
        levelLabel.verticalAlignmentMode = .center
        
        addChild(levelLabel)
    }
    
    // MARK: - Utility Methods
    
    func positionForGridCell(row: Int, col: Int) -> CGPoint {
        // Вычисляем позицию ячейки в координатах сцены
        let x = cellSize * CGFloat(col) + cellSize / 2
        let y = size.height - (cellSize * CGFloat(row) + cellSize / 2)
        return CGPoint(x: x, y: y)
    }
    
    func gridCellForPosition(_ position: CGPoint) -> (row: Int, col: Int)? {
        // Преобразуем позицию в координаты сетки
        let col = Int(position.x / cellSize)
        let row = Int((size.height - position.y) / cellSize)
        
        // Проверяем, что координаты находятся в пределах сетки
        guard row >= 0, row < gridHeight, col >= 0, col < gridWidth else {
            return nil
        }
        
        return (row, col)
    }
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameRunning, let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        // Проверяем, нажал ли игрок на корабль
        let nodes = nodes(at: location)
        for node in nodes {
            if let shipNode = node as? SKShapeNode, shipNode.name == "ship" {
                // Проверяем, движется ли уже корабль
                if let isMovingValue = shipNode.userData?.value(forKey: "isMoving") as? Bool, !isMovingValue {
                    startShipMovement(shipNode)
                    return
                }
            } else if node.name == "direction_label" {
                // Проверяем, не является ли родительский узел кораблем
                if let parentNode = node.parent as? SKShapeNode, parentNode.name == "ship" {
                    if let isMovingValue = parentNode.userData?.value(forKey: "isMoving") as? Bool, !isMovingValue {
                        startShipMovement(parentNode)
                        return
                    }
                }
            }
        }
    }
    
    private func startShipMovement(_ shipNode: SKShapeNode) {
        updateDebugLabel("Корабль начал движение!")
        
        // Помечаем корабль как движущийся
        shipNode.userData?.setValue(true, forKey: "isMoving")
        
        // Останавливаем анимацию пульсации
        shipNode.removeAllActions()
        
        // Определяем направление движения в зависимости от поворота корабля
        let direction = getMovementDirectionFromRotation(shipNode.zRotation)
        
        // Получаем текущую позицию в сетке
        if let gridPositionString = shipNode.userData?.value(forKey: "gridPosition") as? String {
            let components = gridPositionString.split(separator: ",")
            if components.count == 2,
               let row = Int(components[0]),
               let col = Int(components[1]) {
                
                // Начинаем движение
                moveShip(shipNode, fromRow: row, fromCol: col, direction: direction)
            }
        }
    }
    
    private func getMovementDirectionFromRotation(_ rotation: CGFloat) -> (rowDelta: Int, colDelta: Int) {
        // Нормализуем угол до диапазона [0, 2π)
        let normalizedRotation = (rotation.truncatingRemainder(dividingBy: 2 * .pi) + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi)
        
        // Определяем направление в зависимости от угла поворота
        if normalizedRotation < 0.25 * .pi || normalizedRotation > 1.75 * .pi {
            return (0, 1) // Вправо
        } else if normalizedRotation < 0.75 * .pi {
            return (1, 0) // Вниз
        } else if normalizedRotation < 1.25 * .pi {
            return (0, -1) // Влево
        } else {
            return (-1, 0) // Вверх
        }
    }
    
    private func moveShip(_ shipNode: SKShapeNode, fromRow row: Int, fromCol col: Int, direction: (rowDelta: Int, colDelta: Int)) {
        // Сохраняем предыдущую позицию
        shipNode.userData?.setValue("\(row),\(col)", forKey: "previousPosition")
        
        // Вычисляем новую позицию
        let newRow = row + direction.rowDelta
        let newCol = col + direction.colDelta
        
        // Проверяем выход за границы
        if newRow < 0 || newRow >= gridHeight || newCol < 0 || newCol >= gridWidth {
            // Корабль покинул поле - считаем это успешным выходом
            updateDebugLabel("Корабль успешно вышел!")
            shipExitedGrid(shipNode)
            return
        }
        
        // Проверяем столкновение с доком
        if let cellType = gridNodes[newRow][newCol].userData?.value(forKey: "type") as? String,
           cellType == "dock" {
            // Столкновение с доком
            updateDebugLabel("Столкновение с доком!")
            handleCollision(shipNode)
            return
        }
        
        // Проверяем столкновение с другими кораблями
        for (_, otherShipNode) in shipNodes {
            if otherShipNode != shipNode,
               let otherPositionString = otherShipNode.userData?.value(forKey: "gridPosition") as? String {
                
                let components = otherPositionString.split(separator: ",")
                if components.count == 2,
                   let otherRow = Int(components[0]),
                   let otherCol = Int(components[1]),
                   otherRow == newRow && otherCol == newCol {
                    
                    // Столкновение с другим кораблем
                    updateDebugLabel("Столкновение с другим кораблем!")
                    handleCollision(shipNode, otherShipNode: otherShipNode)
                    return
                }
            }
        }
        
        // Проверяем, является ли новая позиция перекрестком
        let isIntersection = gridNodes[newRow][newCol].userData?.value(forKey: "type") as? String == "intersection"
        
        // Обновляем позицию корабля в сетке
        shipNode.userData?.setValue("\(newRow),\(newCol)", forKey: "gridPosition")
        
        // Получаем новую позицию на экране
        let newPosition = positionForGridCell(row: newRow, col: newCol)
        
        // Анимируем движение
        let moveDuration = 0.3
        let moveAction = SKAction.move(to: newPosition, duration: moveDuration)
        
        shipNode.run(moveAction) { [weak self] in
            guard let self = self else { return }
            
            // Если достигли перекрестка, применяем правило поворота
            if isIntersection {
                self.handleIntersection(shipNode)
            }
            
            // Продолжаем движение в текущем направлении
            let currentDirection = self.getMovementDirectionFromRotation(shipNode.zRotation)
            self.moveShip(shipNode, fromRow: newRow, fromCol: newCol, direction: currentDirection)
        }
    }
    
    private func handleIntersection(_ shipNode: SKShapeNode) {
        // Проверяем, сколько перекрестков уже пройдено
        if let intersectionsPassed = shipNode.userData?.value(forKey: "intersectionsPassed") as? Int,
           let turnPatternValue = shipNode.userData?.value(forKey: "turnPattern") as? String,
           let turnPattern = TurnDirection(rawValue: turnPatternValue) {
            
            // Применяем поворот только на первом перекрестке
            if intersectionsPassed == 0 {
                // Определяем новый угол поворота в зависимости от паттерна
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
                
                // Применяем поворот
                let newRotation = shipNode.zRotation + rotationDelta
                let rotateAction = SKAction.rotate(toAngle: newRotation, duration: 0.2)
                shipNode.run(rotateAction)
            }
            
            // Увеличиваем счетчик пройденных перекрестков
            shipNode.userData?.setValue(intersectionsPassed + 1, forKey: "intersectionsPassed")
        }
    }
    
    private func handleCollision(_ shipNode: SKShapeNode, otherShipNode: SKShapeNode? = nil) {
        // Анимация столкновения
        let redColorAction = SKAction.colorize(with: .red, colorBlendFactor: 1.0, duration: 0.2)
        shipNode.run(redColorAction)
        otherShipNode?.run(redColorAction)
        
        // Останавливаем игру
        isGameRunning = false
        
        // Уведомляем ViewModel о столкновении
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel?.shipCollision()
        }
    }
    
    private func shipExitedGrid(_ shipNode: SKShapeNode) {
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
        
        // Добавляем эффект завершения уровня
        let levelCompleteLabel = SKLabelNode(fontNamed: "Arial-Bold")
        levelCompleteLabel.text = "УРОВЕНЬ ПРОЙДЕН!"
        levelCompleteLabel.fontSize = 40
        levelCompleteLabel.fontColor = .green
        levelCompleteLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        levelCompleteLabel.zPosition = 100
        levelCompleteLabel.horizontalAlignmentMode = .center
        levelCompleteLabel.alpha = 0
        
        addChild(levelCompleteLabel)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let wait = SKAction.wait(forDuration: 0.5)
        
        levelCompleteLabel.run(SKAction.sequence([
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
        gridNodes.removeAll()
        
        // Настраиваем сцену заново
        setupDebugLabel()
        calculateCellSize()
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
