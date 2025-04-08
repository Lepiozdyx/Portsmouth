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
    
    /// Продолжить игру
    func resumeGame() {
        gameState = .playing
    }
    
    /// Завершить уровень успехом
    func completeLevel() {
        // Получаем ID текущего уровня
        guard let currentLevelId = currentLevel?.id else {
            return
        }
        
        // Добавляем монеты за прохождение
        progressService.addCoins(100)
        loadUserProgress()
        
        // Отмечаем уровень как пройденный без столкновений
        // (здесь мы всегда отмечаем как успешный, т.к. метод вызывается только при успехе)
        CollisionTrackerService.shared.markLevelAsCollisionFree(levelId: currentLevelId)
        
        // Разблокируем следующий уровень, если он существует
        if let nextLevel = levelManager.level(with: currentLevelId + 1) {
            progressService.unlockLevel(id: nextLevel.id)
            loadUserProgress()
        }
        
        // Проверяем достижения
        AchievementService.shared.checkAchievements(completedLevelId: currentLevelId)
        
        gameState = .victory
    }
    
    /// Завершить уровень поражением
    func gameover() {
        // Получаем ID текущего уровня
        if let currentLevelId = currentLevel?.id {
            // Отмечаем, что уровень был пройден со столкновением
            CollisionTrackerService.shared.markLevelWithCollision(levelId: currentLevelId)
        }
        
        gameState = .gameOver
    }
    
    /// Вернуться в главное меню
    func returnToMainMenu() {
        // Очищаем currentLevel для избежания утечек памяти
        currentLevel = nil
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
        // Сохраняем ID текущего уровня перед перезапуском
        if let levelId = currentLevel?.id {
            // Сначала меняем состояние, чтобы произошло обновление всех связанных вью
            gameState = .menu
            
            // Используем DispatchQueue чтобы дать время для обновления вью
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.startGame(levelId: levelId)
            }
        }
    }
    
    // MARK: - Вспомогательные методы
    
    /// Загрузить прогресс пользователя
    func loadUserProgress() {
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
