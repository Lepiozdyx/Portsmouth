import Foundation
import Combine

/// ViewModel для управления общим состоянием игры
class GameViewModel: ObservableObject {
    // MARK: - Published свойства
    
    /// Текущее состояние игры
    @Published var gameState: GameState = .menu
    
    /// Текущий выбранный уровень
    @Published var currentLevel: LevelModel?
    
    /// Прогресс пользователя
    @Published var coins: Int = 0
    @Published var unlockedLevelIds: Set<Int> = []
    
    // MARK: - Сервисы
    
    private let levelManager = LevelManager.shared
    private let progressService = UserProgressService.shared
    
    // MARK: - Lifecycle
    
    init() {
        // Загружаем прогресс пользователя
        loadUserProgress()
    }
    
    // MARK: - Методы управления состоянием
    
    /// Перейти к экрану выбора уровня
    func showLevelSelection() {
        gameState = .levelSelect
    }
    
    /// Начать игру на выбранном уровне
    func startGame(levelId: Int) {
        guard let level = levelManager.level(with: levelId),
              progressService.isLevelUnlocked(id: levelId) else {
            return
        }
        
        currentLevel = level
        gameState = .playing
    }
    
    /// Начать тестовый уровень
    func startTestLevel() {
        currentLevel = levelManager.getTestLevel()
        gameState = .playing
    }
    
    /// Поставить игру на паузу
    func pauseGame() {
        gameState = .paused
    }
    
    /// Продолжить игру
    func resumeGame() {
        gameState = .playing
    }
    
    /// Завершить уровень успехом
    func completeLevel() {
        // Добавляем монеты за прохождение
        progressService.addCoins(100)
        loadUserProgress()
        
        // Разблокируем следующий уровень, если он существует
        if let currentId = currentLevel?.id,
           let nextLevel = levelManager.level(with: currentId + 1) {
            progressService.unlockLevel(id: nextLevel.id)
        }
        
        gameState = .victory
    }
    
    /// Завершить уровень поражением
    func gameover() {
        gameState = .gameOver
    }
    
    /// Вернуться в главное меню
    func returnToMainMenu() {
        gameState = .menu
    }
    
    /// Перейти к следующему уровню
    func goToNextLevel() {
        if let currentId = currentLevel?.id,
           let nextLevel = levelManager.level(with: currentId + 1),
           progressService.isLevelUnlocked(id: nextLevel.id) {
            currentLevel = nextLevel
            gameState = .playing
        } else {
            returnToMainMenu()
        }
    }
    
    /// Перезапустить текущий уровень
    func restartLevel() {
        if let levelId = currentLevel?.id {
            startGame(levelId: levelId)
        }
    }
    
    // MARK: - Вспомогательные методы
    
    /// Загрузить прогресс пользователя
    private func loadUserProgress() {
        coins = progressService.getCoins()
        unlockedLevelIds = progressService.userProgress.unlockedLevelIds
    }
    
    /// Проверить, разблокирован ли уровень
    func isLevelUnlocked(id: Int) -> Bool {
        return progressService.isLevelUnlocked(id: id)
    }
    
    /// Получить все доступные уровни
    func getAllLevels() -> [LevelModel] {
        return levelManager.levels
    }
}
