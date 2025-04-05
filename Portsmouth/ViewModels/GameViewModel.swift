import Foundation
import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // MARK: - Published properties
    @Published var player: Player
    @Published var levels: [Level] = []
    @Published var currentLevel: Level?
    @Published var gameState: GameState = .menu
    
    // Game events
    @Published var isLevelCompleted: Bool = false
    @Published var isGameOver: Bool = false
    
    // Shop items
    @Published var shopItems: [ShopItem] = []
    
    // Achievements
    @Published var achievements: [Achievement] = []
    
    // MARK: - Private properties
    private var consecutiveSuccessfulShips = 0
    private var dataManager = DataManager.shared
    
    // MARK: - Initialization
    
    init() {
        // Загрузка данных игрока
        player = dataManager.loadPlayer()
        
        // Настройка уровней
        setupLevels()
        
        // Настройка магазина
        setupShopItems()
        
        // Настройка достижений
        setupAchievements()
    }
    
    // MARK: - Game state enum
    
    enum GameState {
        case menu
        case levelSelection
        case playing
        case gameOver
        case victory
        case shop
        case achievements
    }
    
    // MARK: - Setup methods
    
    private func setupLevels() {
        // Создаем 10 уровней с разной сложностью
        levels = (1...10).map { levelId in
            createLevel(id: levelId)
        }
    }
    
    private func createLevel(id: Int) -> Level {
        // Настраиваем уровень в зависимости от его ID
        // В реальной игре здесь будет более сложная логика
        
        var ships: [Ship] = []
        var intersections: [Intersection] = []
        
        // Для упрощенной версии мы будем использовать шаблонные перекрестки
        // и формировать корабли в коде GameScene
        
        return Level(
            id: id,
            name: "Уровень \(id)",
            ships: ships, // Пустой массив, корабли будут создаваться в GameScene
            backgroundType: player.currentBackgroundEnum,
            isUnlocked: id == 1 || player.completedLevels[id - 1] == true,
            intersections: intersections // Пустой массив, перекрестки будут созданы в GameScene
        )
    }
    
    private func setupShopItems() {
        // Создаем товары для магазина
        var items: [ShopItem] = []
        
        // Скины кораблей
        for shipType in ShipType.allCases {
            let isUnlocked = player.isShipTypeUnlocked(shipType)
            let item = ShopItem(itemType: .shipSkin(shipType), isUnlocked: isUnlocked)
            items.append(item)
        }
        
        // Фоны
        for backgroundType in BackgroundType.allCases {
            let isUnlocked = player.isBackgroundUnlocked(backgroundType)
            let item = ShopItem(itemType: .background(backgroundType), isUnlocked: isUnlocked)
            items.append(item)
        }
        
        shopItems = items
    }
    
    private func setupAchievements() {
        // Создаем список достижений
        achievements = AchievementType.allCases.map { type in
            let isUnlocked = player.isAchievementUnlocked(type)
            let isRewardClaimed = player.isAchievementRewardClaimed(type)
            return Achievement(type: type, isUnlocked: isUnlocked, isRewardClaimed: isRewardClaimed)
        }
    }
    
    // MARK: - Game flow methods
    
    func selectLevel(_ level: Level) {
        if level.isUnlocked {
            // Сначала сбрасываем состояние игры
            resetGameState()
            
            // Устанавливаем текущий уровень
            currentLevel = level
            
            // Затем устанавливаем состояние .playing
            gameState = .playing
        }
    }
    
    func resetGameState() {
        isLevelCompleted = false
        isGameOver = false
        
        // Если мы находимся в состоянии gameOver или victory, переходим в состояние playing
        if gameState == .gameOver || gameState == .victory {
            gameState = .playing
        }
        
        // Сбрасываем счетчик успешных кораблей
        consecutiveSuccessfulShips = 0
    }
    
    // Метод вызывается, когда корабль успешно выходит из уровня
    func shipReachedExit() {
        consecutiveSuccessfulShips += 1
        
        // Проверка достижения "Судоходный стратег"
        if consecutiveSuccessfulShips >= 5 {
            player.unlockAchievement(.shippingStrategist)
            dataManager.savePlayer(player)
            setupAchievements() // Обновляем список достижений
        }
    }
    
    // Метод вызывается, когда происходит столкновение кораблей
    func shipCollision() {
        // Проверяем, не находимся ли мы уже в состоянии столкновения
        guard !isGameOver && gameState != .gameOver else { return }
        
        consecutiveSuccessfulShips = 0 // Сбрасываем счетчик
        isGameOver = true
        gameState = .gameOver
    }
    
    // Метод вызывается, когда все корабли успешно вышли из уровня
    func completeLevel() {
        guard let level = currentLevel else { return }
        
        // Обновляем прогресс игрока
        player.completedLevels[level.id] = true
        player.coins += 100 // Награда за уровень
        
        // Проверяем достижения
        dataManager.checkAchievements(player: &player, completedLevelId: level.id)
        
        // Разблокируем следующий уровень, если он существует
        if level.id < levels.count {
            levels[level.id].isUnlocked = true
        }
        
        // Сохраняем прогресс
        dataManager.savePlayer(player)
        
        // Обновляем UI
        isLevelCompleted = true
        gameState = .victory
        setupAchievements() // Обновляем список достижений
    }
    
    func restartLevel() {
        // Обязательно сбрасываем флаги состояния
        resetGameState()
        
        // Затем устанавливаем состояние .playing
        gameState = .playing
    }
    
    func nextLevel() {
        guard let currentLevel = currentLevel else {
            gameState = .menu
            return
        }
        
        // Проверяем, есть ли следующий уровень
        let nextLevelId = currentLevel.id + 1
        if nextLevelId <= levels.count {
            // Находим следующий уровень в списке
            if let nextLevel = levels.first(where: { $0.id == nextLevelId }) {
                // Выбираем следующий уровень
                selectLevel(nextLevel)
            } else {
                // Если не нашли, возвращаемся в меню
                gameState = .menu
            }
        } else {
            // Если нет следующего уровня, возвращаемся в меню
            gameState = .menu
        }
    }
    
    func goToMenu() {
        gameState = .menu
    }
    
    // MARK: - Shop methods
    
    func buyItem(_ item: ShopItem) {
        guard !item.isUnlocked && player.coins >= item.price else { return }
        
        // Списываем монеты
        player.coins -= item.price
        
        // Разблокируем предмет
        switch item.itemType {
        case .shipSkin(let shipType):
            player.unlockedShipTypes.insert(shipType.rawValue)
        case .background(let backgroundType):
            player.unlockedBackgrounds.insert(backgroundType.rawValue)
        }
        
        // Сохраняем прогресс
        dataManager.savePlayer(player)
        
        // Обновляем список товаров
        setupShopItems()
    }
    
    func selectShipType(_ type: ShipType) {
        guard player.isShipTypeUnlocked(type) else { return }
        player.currentShipType = type.rawValue
        dataManager.savePlayer(player)
    }
    
    func selectBackgroundType(_ type: BackgroundType) {
        guard player.isBackgroundUnlocked(type) else { return }
        player.currentBackground = type.rawValue
        dataManager.savePlayer(player)
    }
    
    // MARK: - Achievement methods
    
    func claimAchievementReward(_ achievement: Achievement) {
        guard achievement.isUnlocked && !achievement.isRewardClaimed else { return }
        
        player.claimAchievementReward(achievement.type)
        dataManager.savePlayer(player)
        
        // Обновляем список достижений
        setupAchievements()
    }
    
    // Метод для проверки достижения "Точный расчёт"
    func checkPreciseCalculationAchievement(ship1PassedTime: TimeInterval, ship2PassedTime: TimeInterval) {
        // Если два корабля прошли через узкий проход с разницей менее 1 секунды
        if abs(ship1PassedTime - ship2PassedTime) < 1.0 {
            player.unlockAchievement(.preciseCalculation)
            dataManager.savePlayer(player)
            setupAchievements()
        }
    }
}
