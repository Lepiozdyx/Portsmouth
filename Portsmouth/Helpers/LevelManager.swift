import Foundation

/// Менеджер уровней - предоставляет доступ к предопределенным уровням игры
class LevelManager {
    // Синглтон для доступа по всему приложению
    static let shared = LevelManager()
    
    // Список всех доступных уровней
    private(set) var levels: [LevelModel]
    
    private init() {
        // Инициализируем предопределенные уровни
        levels = Self.createPredefinedLevels()
    }
    
    /// Получить уровень по ID
    func level(with id: Int) -> LevelModel? {
        return levels.first { $0.id == id }
    }
    
    /// Получить тестовый уровень (как на схеме)
    func getTestLevel() -> LevelModel {
        return levels[0] // Первый уровень - тестовый
    }
    
    /// Создание предопределенных уровней
    private static func createPredefinedLevels() -> [LevelModel] {
        // Тестовый уровень (первый), соответствующий схеме
        let testLevel = createTestLevel()
        
        // Дополнительные уровни будут добавлены здесь
        // ...
        
        return [testLevel]
    }
    
    /// Создание тестового уровня, как показано на схеме
    private static func createTestLevel() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем корабли в соответствии со схемой
        let ships: [ShipModel] = [
            // Корабль сверху
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 9),
                direction: .south,
                turnPattern: .straight
            ),
            // Корабль слева
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 7),
                direction: .east,
                turnPattern: .right
            ),
            // Корабль справа
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .east,
                turnPattern: .left
            ),
            // Корабль снизу
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .north,
                turnPattern: .right
            )
        ]
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 8, y: 7))
        ]
        
        // 3. Создаем препятствия (порты/доки) в соответствии со схемой
        var obstacles: [ObstacleModel] = []
        
        // Верхний левый блок препятствий (3x4)
        for x in 1...3 {
            for y in 8...11 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // Верхний правый блок препятствий (3x4)
        for x in 5...7 {
            for y in 8...11 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // Нижний левый блок препятствий (3x4)
        for x in 1...3 {
            for y in 3...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // Нижний правый блок препятствий (3x4)
        for x in 5...7 {
            for y in 3...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 1,
            name: "Test Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
}
