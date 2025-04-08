import SpriteKit
import SwiftUICore
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Константы для физики
    
    private struct PhysicsCategory {
        static let none: UInt32 = 0
        static let ship: UInt32 = 0x1 << 0
        static let boundary: UInt32 = 0x1 << 1
        static let obstacle: UInt32 = 0x1 << 2
        static let all: UInt32 = UInt32.max
    }
    
    // MARK: - Свойства
    
    /// ViewModel для текущего уровня
    var levelViewModel: LevelViewModel!
    
    /// Размер ячейки сетки
    private var cellSize: CGFloat = 40
    
    /// Словарь корабельных узлов, индексированных по их ID
    private var shipNodes = [UUID: ShipNode]()
    
    /// Словарь перекрестков, индексированных по их позиции
    private var intersectionPositions = Set<GridPosition>()
    
    /// Набор позиций препятствий
    private var obstaclePositions = Set<GridPosition>()
    
    /// Размеры реального экрана и безопасные области
    private var screenSize: CGSize = .zero
    private var safeAreaInsets: UIEdgeInsets = .zero
    
    /// Узел-контейнер для игрового поля (для центрирования)
    private var gameContainerNode: SKNode?
    
    /// Фоновая текстура воды
    private var waterBackgroundNode: SKSpriteNode?
    
    // MARK: - Жизненный цикл
    
    override func didMove(to view: SKView) {
        // Устанавливаем начальные размеры, если они еще не установлены
        if screenSize == .zero {
            screenSize = view.bounds.size
        }
        
        // Настройка физики
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // Настройка фона с текстурой воды вместо сплошного цвета
        setupWaterBackground()
        
        // Загрузка уровня
        setupLevel()
        
        // Добавляем границы сцены для определения выхода кораблей
        setupScreenBoundaries()
    }
    
    // MARK: - Настройка фона с текстурой воды
    
    private func setupWaterBackground() {
        // Удаляем старый фоновый узел, если он существует
        waterBackgroundNode?.removeFromParent()
        
        // Загружаем текстуру воды
        let waterTexture = SKTexture(imageNamed: "bgclassic")
        
        // Создаем большой спрайт, который будет покрывать весь экран
        let backgroundSprite = SKSpriteNode(texture: waterTexture)
        
        // Устанавливаем размер спрайта, чтобы он покрывал весь экран
        // и немного больше для гарантии отсутствия пустых краев
        let scale = max(
            screenSize.width / waterTexture.size().width,
            screenSize.height / waterTexture.size().height
        ) + 0.1
        
        backgroundSprite.size = CGSize(
            width: waterTexture.size().width * scale,
            height: waterTexture.size().height * scale
        )
        
        // Центрируем фон по сцене
        backgroundSprite.position = CGPoint(x: screenSize.width / 2, y: screenSize.height / 2)
        
        // Размещаем фон ниже всех остальных элементов
        backgroundSprite.zPosition = -100
        
        // Устанавливаем режим повторения текстуры
        backgroundSprite.texture?.filteringMode = .nearest
        
        // Добавляем фон на сцену
        addChild(backgroundSprite)
        waterBackgroundNode = backgroundSprite
        
        // Устанавливаем прозрачный цвет фона сцены
        backgroundColor = .clear
    }
    
    // MARK: - Обновление размеров
    
    /// Обновить размеры сцены на основе размера экрана
    func updateSceneSize(size: CGSize, safeArea: EdgeInsets) {
        screenSize = size
        safeAreaInsets = UIEdgeInsets(
            top: safeArea.top,
            left: safeArea.leading,
            bottom: safeArea.bottom,
            right: safeArea.trailing
        )
        
        // Обновляем размер сцены
        self.size = size
        
        // Обновляем фон с водой
        setupWaterBackground()
        
        // Если уровень уже настроен, обновим его размеры
        if let level = levelViewModel?.level, gameContainerNode != nil {
            updateCellSize(level: level)
            recenterGameBoard()
        }
    }
    
    private func updateCellSize(level: LevelModel) {
        // Вычисляем размер ячейки на основе размера экрана и размера сетки
        // с учетом безопасных областей и небольшого отступа
        let padding: CGFloat = 0.0
        
        let availableWidth = screenSize.width - safeAreaInsets.left - safeAreaInsets.right - (padding * 2)
        let availableHeight = screenSize.height - safeAreaInsets.top - safeAreaInsets.bottom - (padding * 2)
        
        let cellWidthByWidth = availableWidth / CGFloat(level.gridSettings.width)
        let cellHeightByHeight = availableHeight / CGFloat(level.gridSettings.height)
        
        // Используем меньший размер для сохранения пропорций
        cellSize = min(cellWidthByWidth, cellHeightByHeight)
        
        // Обновляем размер ячейки в модели
        levelViewModel.updateCellSize(cellSize)
    }
    
    private func recenterGameBoard() {
        guard let level = levelViewModel?.level,
              let gameContainer = gameContainerNode else { return }
        
        // Вычисляем полный размер игрового поля
        let gridWidth = CGFloat(level.gridSettings.width) * cellSize
        let gridHeight = CGFloat(level.gridSettings.height) * cellSize
        
        // Центрируем игровое поле в сцене
        let centerX = (screenSize.width - gridWidth) / 2
        let centerY = (screenSize.height - gridHeight) / 2
        
        gameContainer.position = CGPoint(x: centerX, y: centerY)
    }
    
    private func setupScreenBoundaries() {
        guard let level = levelViewModel?.level else { return }
        
        // Создаем физические границы вокруг видимой области игрового поля
        let gridWidth = CGFloat(level.gridSettings.width) * cellSize
        let gridHeight = CGFloat(level.gridSettings.height) * cellSize
        
        let boundaryRect = CGRect(x: 0, y: 0, width: gridWidth, height: gridHeight)
        let borderBody = SKPhysicsBody(edgeLoopFrom: boundaryRect)
        borderBody.categoryBitMask = PhysicsCategory.boundary
        borderBody.contactTestBitMask = PhysicsCategory.ship
        borderBody.collisionBitMask = PhysicsCategory.none
        
        if let gameContainer = gameContainerNode {
            gameContainer.physicsBody = borderBody
        }
    }
    
    // MARK: - Настройка уровня
    
    private func setupLevel() {
        guard let level = levelViewModel?.level else { return }
        
        // Очищаем предыдущие ноды (это удаляет и фон)
        removeAllChildren()
        
        // Устанавливаем фон после очистки сцены
        setupWaterBackground()
        
        // Очищаем коллекции
        shipNodes.removeAll()
        intersectionPositions.removeAll()
        obstaclePositions.removeAll()
        
        updateCellSize(level: level)
        
        // Создаем контейнер для игровых элементов
        let gameContainer = SKNode()
        addChild(gameContainer)
        gameContainerNode = gameContainer
        
        // Отрисовка игрового поля: сетка, препятствия, перекрестки, корабли
        setupGrid(width: level.gridSettings.width, height: level.gridSettings.height, parent: gameContainer)
        setupObstacles(level.obstacles, parent: gameContainer)
        setupIntersections(level.intersections, parent: gameContainer)
        setupShips(level.ships, parent: gameContainer)
        
        recenterGameBoard()
        setupScreenBoundaries()
    }
    
    private func setupGrid(width: Int, height: Int, parent: SKNode) {
        // Отрисовка сетки для отладки
        let gridNode = SKNode()
        
        for x in 0...width {
            let xPos = CGFloat(x) * cellSize
            let path = CGMutablePath()
            path.move(to: CGPoint(x: xPos, y: 0))
            path.addLine(to: CGPoint(x: xPos, y: CGFloat(height) * cellSize))
            
            let line = SKShapeNode(path: path)
            line.strokeColor = .clear
            line.lineWidth = 0.5
            line.alpha = 0.3
            gridNode.addChild(line)
        }
        
        for y in 0...height {
            let yPos = CGFloat(y) * cellSize
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 0, y: yPos))
            path.addLine(to: CGPoint(x: CGFloat(width) * cellSize, y: yPos))
            
            let line = SKShapeNode(path: path)
            line.strokeColor = .clear
            line.lineWidth = 0.5
            line.alpha = 0.3
            gridNode.addChild(line)
        }
        
        parent.addChild(gridNode)
    }
    
    private func setupObstacles(_ obstacles: [ObstacleModel], parent: SKNode) {
        for obstacle in obstacles {
            // Сохраняем позицию препятствия
            obstaclePositions.insert(obstacle.gridPosition)
            
            // Создаем визуальное представление препятствия
            let position = obstacle.gridPosition.toPoint(cellSize: cellSize)
            let obstacleNode = SKSpriteNode(color: .gray, size: CGSize(width: cellSize, height: cellSize))
            obstacleNode.position = position
            
            // Настройка физического тела
            obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cellSize, height: cellSize))
            obstacleNode.physicsBody?.isDynamic = false
            obstacleNode.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
            obstacleNode.physicsBody?.contactTestBitMask = PhysicsCategory.none
            obstacleNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            parent.addChild(obstacleNode)
        }
    }
    
    private func setupIntersections(_ intersections: [IntersectionModel], parent: SKNode) {
        for intersection in intersections {
            // Сохраняем позицию перекрестка
            intersectionPositions.insert(intersection.gridPosition)
            
            // Создаем визуальное представление перекрестка (опционально для отладки)
            let position = intersection.gridPosition.toPoint(cellSize: cellSize)
            let intersectionNode = SKShapeNode(circleOfRadius: cellSize / 4)
            intersectionNode.position = position
            intersectionNode.fillColor = .yellow
            intersectionNode.alpha = 0.0
            
            parent.addChild(intersectionNode)
        }
    }
    
    private func setupShips(_ ships: [ShipModel], parent: SKNode) {
        for ship in ships {
            // Создаем корабль
            let position = ship.initialGridPosition.toPoint(cellSize: cellSize)
            let shipNode = ShipNode(
                size: CGSize(width: cellSize * 0.8, height: cellSize * 0.8),
                direction: ship.direction,
                turnPattern: ship.turnPattern,
                id: ship.id
            )
            shipNode.position = position
            
            // Настраиваем тело для физики
            shipNode.setupPhysicsBody(radius: cellSize * 0.4, categoryBitMask: PhysicsCategory.ship)
            
            // Добавляем обработчик нажатия
            shipNode.setupTapHandler { [weak self] in
                self?.startShipMovement(shipNode)
            }
            
            // Добавляем в словарь и на сцену
            shipNodes[ship.id] = shipNode
            parent.addChild(shipNode)
        }
    }
    
    // MARK: - Управление кораблями
    
    private func startShipMovement(_ shipNode: ShipNode) {
        // Проверка, что корабль ещё не движется
        if shipNode.isMoving {
            return
        }
        
        // Устанавливаем флаг движения
        shipNode.isMoving = true
        
        // Начинаем движение
        moveShip(shipNode)
        
        // Уведомляем ViewModel
        levelViewModel.startShipMovement(shipId: shipNode.id)
    }
    
    private func moveShip(_ shipNode: ShipNode) {
        // Получаем вектор движения из направления
        let direction = shipNode.direction
        let moveVector = direction.vector
        
        // Вычисляем следующую позицию
        let nextX = shipNode.position.x + moveVector.dx * cellSize
        let nextY = shipNode.position.y + moveVector.dy * cellSize
        let nextPosition = CGPoint(x: nextX, y: nextY)
        
        // Создаем действие движения
        let moveAction = SKAction.move(to: nextPosition, duration: 0.5)
        
        // Выполняем действие и проверяем статус после завершения
        shipNode.run(moveAction) { [weak self] in
            guard let self = self else { return }
            
            // Проверяем, находится ли корабль на перекрестке
            let gridPosition = self.scenePositionToGridPosition(shipNode.position)
            if self.intersectionPositions.contains(gridPosition) {
                self.handleShipAtIntersection(shipNode)
            }
            
            // Продолжаем движение, если корабль все еще на сцене
            if shipNode.parent != nil {
                self.moveShip(shipNode)
            }
        }
    }
    
    private func handleShipAtIntersection(_ shipNode: ShipNode) {
        // Получаем новое направление в зависимости от паттерна поворота
        let oldDirection = shipNode.direction
        let newDirection = oldDirection.direction(after: shipNode.turnPattern)
        
        // Если направление изменилось, обновляем его и выполняем анимацию поворота
        if oldDirection != newDirection {
            shipNode.direction = newDirection
            // Дополнительно: можно явно вызвать анимацию, если это необходимо
            shipNode.applyCorrectRotation(animated: true)
        }
    }
    
    private func shipExitedScreen(_ shipNode: ShipNode) {
        // Удаляем корабль со сцены
        shipNode.removeFromParent()
        shipNodes.removeValue(forKey: shipNode.id)
        
        // Уведомляем ViewModel о завершении пути корабля
        levelViewModel.shipCompletedPath()
    }
    
    // MARK: - Физика и столкновения
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Получаем узлы, участвующие в контакте
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        // Проверяем столкновение кораблей между собой
        if bodyA.categoryBitMask == PhysicsCategory.ship && bodyB.categoryBitMask == PhysicsCategory.ship {
            // Столкновение кораблей - проигрыш
            handleShipCollision()
            return
        }
        
        // Проверяем выход корабля за пределы экрана
        if (bodyA.categoryBitMask == PhysicsCategory.ship && bodyB.categoryBitMask == PhysicsCategory.boundary) ||
            (bodyA.categoryBitMask == PhysicsCategory.boundary && bodyB.categoryBitMask == PhysicsCategory.ship) {
            
            let shipBody = (bodyA.categoryBitMask == PhysicsCategory.ship) ? bodyA : bodyB
            
            // Находим соответствующий корабль
            if let shipNode = shipBody.node as? ShipNode {
                shipExitedScreen(shipNode)
            }
        }
    }
    
    private func handleShipCollision() {
        // Останавливаем все корабли
        for (_, shipNode) in shipNodes {
            shipNode.removeAllActions()
        }
        
        // Анимация столкновения
        performCollisionAnimation()
        
        // Уведомляем ViewModel о столкновении
        levelViewModel.shipCollision()
    }
    
    private func performCollisionAnimation() {
        // Анимация взрыва или другой эффект
        let explosionNode = SKSpriteNode(color: .red, size: CGSize(width: cellSize * 2, height: cellSize * 2))
        explosionNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        explosionNode.zPosition = 10
        
        // Анимация пульсации
        let scaleUpAction = SKAction.scale(to: 1.5, duration: 0.2)
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.3)
        let sequence = SKAction.sequence([scaleUpAction, fadeOutAction, SKAction.removeFromParent()])
        
        addChild(explosionNode)
        explosionNode.run(sequence)
    }
    
    // MARK: - Вспомогательные методы
    
    /// Преобразование позиции сцены в координаты сетки
    private func scenePositionToGridPosition(_ position: CGPoint) -> GridPosition {
        let x = Int(position.x / cellSize)
        let y = Int(position.y / cellSize)
        return GridPosition(x: x, y: y)
    }
    
    // MARK: - Обработка касаний (для перезапуска уровня)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Дополнительная логика обработки касаний может быть добавлена здесь
    }
}
