import Foundation

// MARK: - Enums

/// Направление движения корабля
enum ShipDirection: String, Codable {
    case north
    case south
    case east
    case west
    
    /// Возвращает вектор движения в соответствии с направлением
    var vector: CGVector {
        switch self {
        case .north: return CGVector(dx: 0, dy: 1)
        case .south: return CGVector(dx: 0, dy: -1)
        case .east: return CGVector(dx: 1, dy: 0)
        case .west: return CGVector(dx: -1, dy: 0)
        }
    }
    
    /// Возвращает угол поворота в радианах
    var angle: CGFloat {
        switch self {
        case .north: return 0
        case .south: return CGFloat.pi
        case .east: return CGFloat.pi / 2
        case .west: return -CGFloat.pi / 2
        }
    }
    
    /// Возвращает новое направление после поворота
    func direction(after turnPattern: TurnPattern) -> ShipDirection {
        switch (self, turnPattern) {
        case (_, .straight): return self
        case (.north, .left): return .west
        case (.north, .right): return .east
        case (.south, .left): return .east
        case (.south, .right): return .west
        case (.east, .left): return .north
        case (.east, .right): return .south
        case (.west, .left): return .south
        case (.west, .right): return .north
        }
    }
}

/// Паттерн поворота корабля при встрече с перекрестком
enum TurnPattern: String, Codable {
    case straight
    case left
    case right
}

/// Тип ячейки игровой сетки
enum CellType: String, Codable {
    case water        // Вода (по ней двигаются корабли)
    case obstacle     // Препятствие (порт, берег)
    case intersection // Перекресток
    case ship         // Корабль (стартовая позиция)
}

/// Состояние игры
enum GameState: Equatable {
    case menu        // Главное меню
    case levelSelect // Выбор уровня
    case playing     // Игровой процесс
    case paused      // Пауза
    case victory     // Победа
    case gameOver    // Поражение
}

// MARK: - Models

/// Модель корабля
struct ShipModel: Identifiable, Codable {
    let id: UUID
    let initialGridPosition: GridPosition
    var direction: ShipDirection
    var turnPattern: TurnPattern
    var isMoving: Bool = false
    
    init(
        id: UUID = UUID(),
        initialGridPosition: GridPosition,
        direction: ShipDirection,
        turnPattern: TurnPattern
    ) {
        self.id = id
        self.initialGridPosition = initialGridPosition
        self.direction = direction
        self.turnPattern = turnPattern
    }
}

/// Модель перекрестка
struct IntersectionModel: Identifiable, Codable {
    let id: UUID
    let gridPosition: GridPosition
    
    init(id: UUID = UUID(), gridPosition: GridPosition) {
        self.id = id
        self.gridPosition = gridPosition
    }
}

/// Модель препятствия
struct ObstacleModel: Identifiable, Codable {
    let id: UUID
    let gridPosition: GridPosition
    
    init(id: UUID = UUID(), gridPosition: GridPosition) {
        self.id = id
        self.gridPosition = gridPosition
    }
}

/// Позиция в игровой сетке
struct GridPosition: Equatable, Codable, Hashable {
    let x: Int
    let y: Int
    
    func toPoint(cellSize: CGFloat) -> CGPoint {
        return CGPoint(x: CGFloat(x) * cellSize + cellSize / 2,
                       y: CGFloat(y) * cellSize + cellSize / 2)
    }
}

/// Настройки игрового поля
struct GridSettings: Codable {
    let width: Int        // Ширина сетки в ячейках
    let height: Int       // Высота сетки в ячейках
    let cellSize: CGFloat // Размер ячейки в точках
    
    static let `default` = GridSettings(width: 10, height: 15, cellSize: 40)
}

/// Модель уровня
struct LevelModel: Identifiable, Codable {
    let id: Int
    let name: String
    let gridSettings: GridSettings
    let ships: [ShipModel]
    let intersections: [IntersectionModel]
    let obstacles: [ObstacleModel]
    
    init(
        id: Int,
        name: String,
        gridSettings: GridSettings = .default,
        ships: [ShipModel],
        intersections: [IntersectionModel],
        obstacles: [ObstacleModel]
    ) {
        self.id = id
        self.name = name
        self.gridSettings = gridSettings
        self.ships = ships
        self.intersections = intersections
        self.obstacles = obstacles
    }
}

/// Модель прогресса пользователя
struct UserProgress: Codable {
    var coins: Int
    var unlockedLevelIds: Set<Int>
    
    init(coins: Int = 0, unlockedLevelIds: Set<Int> = [1]) {
        self.coins = coins
        self.unlockedLevelIds = unlockedLevelIds
    }
    
    mutating func unlockLevel(id: Int) {
        unlockedLevelIds.insert(id)
    }
    
    mutating func addCoins(_ amount: Int) {
        coins += amount
    }
    
    func isLevelUnlocked(id: Int) -> Bool {
        return unlockedLevelIds.contains(id)
    }
}
