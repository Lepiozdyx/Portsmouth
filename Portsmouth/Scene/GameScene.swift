import SpriteKit
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
    
    // MARK: - Жизненный цикл
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.blue.withAlphaComponent(0.5) // Светло-голубой цвет для воды
        
        // Настройка физики
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // Загрузка уровня
        setupLevel()
        
        // Добавляем границы сцены для определения выхода кораблей
        setupScreenBoundaries()
    }
    
    private func setupScreenBoundaries() {
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.categoryBitMask = PhysicsCategory.boundary
        borderBody.contactTestBitMask = PhysicsCategory.ship
        borderBody.collisionBitMask = PhysicsCategory.none
        
        self.physicsBody = borderBody
    }
    
    // MARK: - Настройка уровня
    
    private func setupLevel() {
        guard let level = levelViewModel?.level else { return }
        
        // Получаем настройки сетки
        cellSize = level.gridSettings.cellSize
        
        // Очищаем предыдущие ноды, если они есть
        removeAllChildren()
        shipNodes.removeAll()
        intersectionPositions.removeAll()
        obstaclePositions.removeAll()
        
        // Устанавливаем размер сцены
        let gridSize = levelViewModel.getGridSizeInPoints()
        size = gridSize
        
        // Отрисовка фона (сетка)
        setupGrid(width: level.gridSettings.width, height: level.gridSettings.height)
        
        // Размещение препятствий
        setupObstacles(level.obstacles)
        
        // Размещение перекрестков
        setupIntersections(level.intersections)
        
        // Размещение кораблей
        setupShips(level.ships)
    }
    
    private func setupGrid(width: Int, height: Int) {
        // Отрисовка сетки для отладки
        let gridNode = SKNode()
        
        for x in 0...width {
            let xPos = CGFloat(x) * cellSize
            let path = CGMutablePath()
            path.move(to: CGPoint(x: xPos, y: 0))
            path.addLine(to: CGPoint(x: xPos, y: CGFloat(height) * cellSize))
            
            let line = SKShapeNode(path: path)
            line.strokeColor = .gray
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
            line.strokeColor = .gray
            line.lineWidth = 0.5
            line.alpha = 0.3
            gridNode.addChild(line)
        }
        
        addChild(gridNode)
    }
    
    private func setupObstacles(_ obstacles: [ObstacleModel]) {
        for obstacle in obstacles {
            // Сохраняем позицию препятствия
            obstaclePositions.insert(obstacle.gridPosition)
            
            // Создаем визуальное представление препятствия
            let position = levelViewModel.gridPositionToScenePosition(obstacle.gridPosition)
            let obstacleNode = SKSpriteNode(color: .brown, size: CGSize(width: cellSize, height: cellSize))
            obstacleNode.position = position
            
            // Настройка физического тела
            obstacleNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: cellSize, height: cellSize))
            obstacleNode.physicsBody?.isDynamic = false
            obstacleNode.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
            obstacleNode.physicsBody?.contactTestBitMask = PhysicsCategory.none
            obstacleNode.physicsBody?.collisionBitMask = PhysicsCategory.none
            
            addChild(obstacleNode)
        }
    }
    
    private func setupIntersections(_ intersections: [IntersectionModel]) {
        for intersection in intersections {
            // Сохраняем позицию перекрестка
            intersectionPositions.insert(intersection.gridPosition)
            
            // Создаем визуальное представление перекрестка (опционально)
            let position = levelViewModel.gridPositionToScenePosition(intersection.gridPosition)
            let intersectionNode = SKShapeNode(circleOfRadius: cellSize / 4)
            intersectionNode.position = position
            intersectionNode.fillColor = .yellow
            intersectionNode.alpha = 0.5 // Полупрозрачное для отладки
            
            addChild(intersectionNode)
        }
    }
    
    private func setupShips(_ ships: [ShipModel]) {
        for ship in ships {
            // Создаем корабль
            let position = levelViewModel.gridPositionToScenePosition(ship.initialGridPosition)
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
            addChild(shipNode)
        }
    }
    
    // MARK: - Управление кораблями
    
    private func startShipMovement(_ shipNode: ShipNode) {
        // Проверка, что корабль ещё не движется
        if shipNode.isMoving {
            return
        }
        
        // Запускаем движение
        shipNode.isMoving = true
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
        let newDirection = shipNode.direction.direction(after: shipNode.turnPattern)
        
        // Сохраняем текущее направление для сравнения
        let oldDirection = shipNode.direction
        
        // Устанавливаем новое направление
        shipNode.direction = newDirection
        
        // Если направление изменилось, выполняем анимацию поворота
        if oldDirection != newDirection {
            performTurnAnimation(shipNode, from: oldDirection, to: newDirection)
        }
    }
    
    private func performTurnAnimation(_ shipNode: ShipNode, from oldDirection: ShipDirection, to newDirection: ShipDirection) {
        // Определяем угол поворота
        let newAngle = newDirection.angle
        
        // Создаем действие поворота
        let rotateAction = SKAction.rotate(toAngle: newAngle, duration: 0.2, shortestUnitArc: true)
        
        // Выполняем анимацию
        shipNode.run(rotateAction)
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
    
    /// Проверка, находится ли позиция за пределами экрана
    private func isOutOfBounds(position: CGPoint) -> Bool {
        return position.x < 0 || position.y < 0 ||
               position.x > size.width || position.y > size.height
    }
    
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
