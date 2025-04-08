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
        return levels[0]
    }
    
    /// Создание предопределенных уровней
    private static func createPredefinedLevels() -> [LevelModel] {
        return [create1Level(), create2Level(), create3Level(), create4Level(), create5Level(), create6Level(), create7Level(), create8Level(), create9Level(), create10Level(), create11Level(), create12Level(), create13Level(), create14Level(), create15Level(), create16Level(), create17Level(), create18Level(), create19Level(), create20Level()]
    }
    
    private static func create1Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем корабли
        let ships: [ShipModel] = [
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 9),
                direction: .south,
                turnPattern: .straight
            ),
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 7),
                direction: .west,
                turnPattern: .straight
            ),
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .west,
                turnPattern: .straight
            )
        ]
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = []
        
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
            name: "1 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create2Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем корабли
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
                turnPattern: .straight
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
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 7))
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
            id: 2,
            name: "2 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create3Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 1...3 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 5...7 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 1...3 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 5...7 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 1...3 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 5...7 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 4),
                direction: .west,
                turnPattern: .right
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 6),
                direction: .south,
                turnPattern: .right
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 7),
                direction: .north,
                turnPattern: .right
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 11),
                direction: .south,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 3,
            name: "3 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create4Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...3 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 5...8 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 0...3 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 5...8 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 0...3 {
            for y in 10...12 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 5...8 {
            for y in 10...12 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 6),
                direction: .south,
                turnPattern: .straight
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 7),
                direction: .north,
                turnPattern: .straight
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 9),
                direction: .west,
                turnPattern: .left
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 4,
            name: "4 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create5Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 1...3 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 5...7 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 1...3 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 5...7 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 1...3 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 5...7 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 4),
                direction: .west,
                turnPattern: .left
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 8, y: 4),
                direction: .west,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 6),
                direction: .south,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 7),
                direction: .north,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 11),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 5,
            name: "5 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create6Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...5 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 7...8 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 0...1 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...5 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 7...8 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 0...5 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 7...8 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 9)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 4),
                direction: .east,
                turnPattern: .right
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .west,
                turnPattern: .straight
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 6),
                direction: .south,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 6),
                direction: .south,
                turnPattern: .right
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .north,
                turnPattern: .right
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 10),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 6,
            name: "6 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create7Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...5 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 7...8 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 0...1 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...5 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 7...8 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 0...1 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 3...5 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 7...8 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 9)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 4),
                direction: .west,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .west,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 6),
                direction: .south,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .north,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 9),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 9),
                direction: .west,
                turnPattern: .right
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 9),
                direction: .east,
                turnPattern: .left
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 7,
            name: "7 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create8Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...3 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...5 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 7...8 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 0...1 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 3...3 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 5...5 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 7...8 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 0...1 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 10
        for x in 3...3 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 11
        for x in 5...5 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 12
        for x in 7...8 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 13
        for x in 0...1 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 14
        for x in 3...3 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 15
        for x in 5...5 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 16
        for x in 7...8 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 10))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 3),
                direction: .south,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 3),
                direction: .north,
                turnPattern: .straight
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .west,
                turnPattern: .straight
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 5),
                direction: .south,
                turnPattern: .right
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .south,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 5),
                direction: .north,
                turnPattern: .straight
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 7),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 7),
                direction: .west,
                turnPattern: .left
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 8),
                direction: .north,
                turnPattern: .left
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 11
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 12
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .north,
                turnPattern: .straight
            ),
            // 13
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 10),
                direction: .west,
                turnPattern: .right
            ),
            // 14
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 10),
                direction: .west,
                turnPattern: .straight
            ),
            // 15
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 11),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 8,
            name: "8 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create9Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...0 {
            for y in 0...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...3 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...5 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 8...8 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...3 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 5...5 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 8...8 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 0...0 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 3...3 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 10
        for x in 5...5 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 11
        for x in 8...8 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 12
        for x in 0...0 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 13
        for x in 3...3 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 14
        for x in 5...5 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 15
        for x in 8...8 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 3)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 1, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 7, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 11))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 1),
                direction: .south,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 1),
                direction: .north,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 2),
                direction: .west,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 2),
                direction: .east,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 3),
                direction: .north,
                turnPattern: .left
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 3),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .north,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .south,
                turnPattern: .straight
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 5),
                direction: .north,
                turnPattern: .right
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 5),
                direction: .north,
                turnPattern: .right
            ),
            // 11
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 6),
                direction: .west,
                turnPattern: .straight
            ),
            // 12
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 6),
                direction: .east,
                turnPattern: .straight
            ),
            // 13
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 7),
                direction: .east,
                turnPattern: .right
            ),
            // 14
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 15
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 9),
                direction: .north,
                turnPattern: .left
            ),
            // 16
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .north,
                turnPattern: .right
            ),
            // 17
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 10),
                direction: .east,
                turnPattern: .left
            ),
            // 18
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 11),
                direction: .west,
                turnPattern: .straight
            ),
            // 19
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 11),
                direction: .west,
                turnPattern: .right
            ),
            // 20
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 11),
                direction: .north,
                turnPattern: .straight
            ),
            // 21
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 12),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 9,
            name: "9 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create10Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 1...3 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 5...7 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 1...3 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 5...7 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 1...3 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 8, y: 4),
                direction: .west,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 6),
                direction: .south,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 7),
                direction: .south,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 11),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 10,
            name: "10 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create11Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...5 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 7...8 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 0...1 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...5 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 7...8 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 0...5 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 7...8 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 9)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 4),
                direction: .west,
                turnPattern: .right
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .west,
                turnPattern: .straight
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 6),
                direction: .south,
                turnPattern: .right
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 6),
                direction: .south,
                turnPattern: .left
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .north,
                turnPattern: .right
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 10),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 11,
            name: "11 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create12Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...5 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 7...8 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 0...1 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...5 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 7...8 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 0...1 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 3...5 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 9)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 4),
                direction: .east,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .west,
                turnPattern: .right
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 6),
                direction: .south,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .north,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 9),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 9),
                direction: .west,
                turnPattern: .right
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 9),
                direction: .west,
                turnPattern: .left
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 12,
            name: "12 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create13Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...3 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...5 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 7...8 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 0...1 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 3...3 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 5...5 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 7...8 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 0...1 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 10
        for x in 3...3 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 11
        for x in 5...5 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 12
        for x in 7...8 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 13
        for x in 0...1 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 14
        for x in 3...3 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 15
        for x in 7...8 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 10))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 3),
                direction: .south,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 3),
                direction: .north,
                turnPattern: .straight
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .west,
                turnPattern: .straight
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 5),
                direction: .north,
                turnPattern: .right
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .south,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 5),
                direction: .north,
                turnPattern: .straight
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 7),
                direction: .west,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 7),
                direction: .west,
                turnPattern: .left
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 8),
                direction: .north,
                turnPattern: .left
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 11
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 8),
                direction: .south,
                turnPattern: .straight
            ),
            // 12
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .north,
                turnPattern: .straight
            ),
            // 13
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 10),
                direction: .west,
                turnPattern: .left
            ),
            // 14
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 10),
                direction: .west,
                turnPattern: .straight
            ),
            // 15
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 11),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 13,
            name: "13 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create14Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...0 {
            for y in 0...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...3 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...5 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 8...8 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...3 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 5...5 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 8...8 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 0...0 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 3...3 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 10
        for x in 5...5 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 11
        for x in 8...8 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 12
        for x in 0...0 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 13
        for x in 3...3 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 14
        for x in 5...5 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 3)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 1, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 7, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 11))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 1),
                direction: .north,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 1),
                direction: .north,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 2),
                direction: .west,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 2),
                direction: .east,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 3),
                direction: .north,
                turnPattern: .left
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 3),
                direction: .west,
                turnPattern: .right
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .north,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .south,
                turnPattern: .straight
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 5),
                direction: .north,
                turnPattern: .right
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 5),
                direction: .south,
                turnPattern: .right
            ),
            // 11
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 6),
                direction: .west,
                turnPattern: .straight
            ),
            // 12
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 6),
                direction: .east,
                turnPattern: .straight
            ),
            // 13
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 7),
                direction: .east,
                turnPattern: .right
            ),
            // 14
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 15
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 9),
                direction: .north,
                turnPattern: .left
            ),
            // 16
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .north,
                turnPattern: .right
            ),
            // 17
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 10),
                direction: .east,
                turnPattern: .left
            ),
            // 18
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 11),
                direction: .west,
                turnPattern: .straight
            ),
            // 19
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 11),
                direction: .west,
                turnPattern: .left
            ),
            // 20
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 11),
                direction: .north,
                turnPattern: .straight
            ),
            // 21
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 12),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 14,
            name: "14 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create15Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 1...3 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 5...7 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...7 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 1...3 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 5...7 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 8, y: 4),
                direction: .west,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 6),
                direction: .south,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 7),
                direction: .north,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 11),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 15,
            name: "15 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create16Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...5 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 7...8 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 0...1 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...5 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 7...8 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 0...5 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 7...8 {
            for y in 10...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 9)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 4),
                direction: .west,
                turnPattern: .left
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .west,
                turnPattern: .straight
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 6),
                direction: .south,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 6),
                direction: .south,
                turnPattern: .right
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .north,
                turnPattern: .right
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 9),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 10),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 16,
            name: "16 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create17Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...5 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 7...8 {
            for y in 1...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 0...1 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...5 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 7...8 {
            for y in 5...8 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 0...1 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 3...5 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 7...8 {
            for y in 10...13 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 9)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 9))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 4),
                direction: .west,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .east,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 4),
                direction: .east,
                turnPattern: .right
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 6),
                direction: .south,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 7),
                direction: .north,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 9),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 9),
                direction: .west,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 9),
                direction: .east,
                turnPattern: .left
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 9),
                direction: .east,
                turnPattern: .left
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 17,
            name: "17 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create18Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...1 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...3 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...5 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 7...8 {
            for y in 0...3 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 0...1 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 3...3 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 5...5 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 7...8 {
            for y in 5...6 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 0...1 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 10
        for x in 3...3 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 11
        for x in 5...5 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 12
        for x in 7...8 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 13
        for x in 0...1 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 14
        for x in 3...3 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 15
        for x in 7...8 {
            for y in 11...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 4)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 10))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 3),
                direction: .south,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 3),
                direction: .north,
                turnPattern: .straight
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 4),
                direction: .east,
                turnPattern: .straight
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 5),
                direction: .south,
                turnPattern: .left
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .south,
                turnPattern: .straight
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 5),
                direction: .north,
                turnPattern: .straight
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 7),
                direction: .east,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 7),
                direction: .west,
                turnPattern: .left
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 8),
                direction: .north,
                turnPattern: .left
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 11
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 12
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .north,
                turnPattern: .straight
            ),
            // 13
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 10),
                direction: .west,
                turnPattern: .right
            ),
            // 14
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 10),
                direction: .west,
                turnPattern: .straight
            ),
            // 15
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 11),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 18,
            name: "18 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create19Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...0 {
            for y in 0...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...3 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...5 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 8...8 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...3 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 5...5 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 8...8 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 0...0 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 3...3 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 10
        for x in 5...5 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 11
        for x in 8...8 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 12
        for x in 0...0 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 13
        for x in 3...3 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 14
        for x in 5...5 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 15
        for x in 8...8 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 3)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 1, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 7, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 11))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 1),
                direction: .north,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 1),
                direction: .south,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 2),
                direction: .west,
                turnPattern: .left
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 2),
                direction: .east,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 3),
                direction: .south,
                turnPattern: .right
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 3),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .north,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .south,
                turnPattern: .straight
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 5),
                direction: .north,
                turnPattern: .right
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 5),
                direction: .north,
                turnPattern: .left
            ),
            // 11
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 6),
                direction: .west,
                turnPattern: .straight
            ),
            // 12
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 6),
                direction: .east,
                turnPattern: .straight
            ),
            // 13
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 7),
                direction: .east,
                turnPattern: .right
            ),
            // 14
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 8),
                direction: .north,
                turnPattern: .straight
            ),
            // 15
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 9),
                direction: .north,
                turnPattern: .left
            ),
            // 16
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .north,
                turnPattern: .right
            ),
            // 17
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 10),
                direction: .east,
                turnPattern: .left
            ),
            // 18
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 11),
                direction: .west,
                turnPattern: .straight
            ),
            // 19
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 11),
                direction: .west,
                turnPattern: .right
            ),
            // 20
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 11),
                direction: .north,
                turnPattern: .straight
            ),
            // 21
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 12),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 19,
            name: "19 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
    
    private static func create20Level() -> LevelModel {
        let gridSettings = GridSettings.default
        
        // 1. Создаем препятствия
        var obstacles: [ObstacleModel] = []
        
        // 1
        for x in 0...0 {
            for y in 0...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2
        for x in 3...3 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 3
        for x in 5...5 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 4
        for x in 8...8 {
            for y in 0...1 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 5
        for x in 3...3 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 6
        for x in 5...5 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 7
        for x in 8...8 {
            for y in 4...5 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 8
        for x in 0...0 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 9
        for x in 3...3 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 10
        for x in 5...5 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 11
        for x in 8...8 {
            for y in 8...9 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 12
        for x in 0...0 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 13
        for x in 3...3 {
            for y in 12...14 {
                obstacles.append(ObstacleModel(gridPosition: GridPosition(x: x, y: y)))
            }
        }
        
        // 2. Создаем перекрестки в соответствии со схемой
        let intersections: [IntersectionModel] = [
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 3)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 2)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 7)),
            IntersectionModel(gridPosition: GridPosition(x: 1, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 7, y: 6)),
            IntersectionModel(gridPosition: GridPosition(x: 2, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 6, y: 10)),
            IntersectionModel(gridPosition: GridPosition(x: 4, y: 11))
        ]
        
        // 3. Создаем корабли
        let ships: [ShipModel] = [
            // 1
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 1),
                direction: .north,
                turnPattern: .straight
            ),
            // 2
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 1),
                direction: .north,
                turnPattern: .left
            ),
            // 3
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 2),
                direction: .west,
                turnPattern: .right
            ),
            // 4
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 2),
                direction: .west,
                turnPattern: .straight
            ),
            // 5
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 3),
                direction: .north,
                turnPattern: .left
            ),
            // 6
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 3),
                direction: .west,
                turnPattern: .left
            ),
            // 7
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 4),
                direction: .north,
                turnPattern: .straight
            ),
            // 8
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 5),
                direction: .south,
                turnPattern: .straight
            ),
            // 9
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 5),
                direction: .south,
                turnPattern: .left
            ),
            // 10
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 5),
                direction: .north,
                turnPattern: .right
            ),
            // 11
            ShipModel(
                initialGridPosition: GridPosition(x: 3, y: 6),
                direction: .west,
                turnPattern: .straight
            ),
            // 12
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 6),
                direction: .east,
                turnPattern: .straight
            ),
            // 13
            ShipModel(
                initialGridPosition: GridPosition(x: 5, y: 7),
                direction: .east,
                turnPattern: .right
            ),
            // 14
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 8),
                direction: .south,
                turnPattern: .straight
            ),
            // 15
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 9),
                direction: .north,
                turnPattern: .left
            ),
            // 16
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 9),
                direction: .north,
                turnPattern: .left
            ),
            // 17
            ShipModel(
                initialGridPosition: GridPosition(x: 1, y: 10),
                direction: .east,
                turnPattern: .left
            ),
            // 18
            ShipModel(
                initialGridPosition: GridPosition(x: 2, y: 11),
                direction: .west,
                turnPattern: .straight
            ),
            // 19
            ShipModel(
                initialGridPosition: GridPosition(x: 6, y: 11),
                direction: .west,
                turnPattern: .right
            ),
            // 20
            ShipModel(
                initialGridPosition: GridPosition(x: 7, y: 11),
                direction: .north,
                turnPattern: .straight
            ),
            // 21
            ShipModel(
                initialGridPosition: GridPosition(x: 4, y: 12),
                direction: .north,
                turnPattern: .straight
            )
        ]
        
        // Создаем и возвращаем модель уровня
        return LevelModel(
            id: 20,
            name: "20 Level",
            gridSettings: gridSettings,
            ships: ships,
            intersections: intersections,
            obstacles: obstacles
        )
    }
}
