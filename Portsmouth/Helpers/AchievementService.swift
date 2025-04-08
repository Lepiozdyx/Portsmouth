import Foundation

class AchievementService {
    static let shared = AchievementService()
    
    private let achievementsKey = "com.riversportsmouth.userAchievements"
    
    // Множество полученных достижений (хранится их ID)
    private(set) var unlockedAchievements: Set<Int> {
        didSet {
            saveAchievements()
        }
    }
    
    private init() {
        self.unlockedAchievements = Set<Int>()
        
        if let loadedAchievements = loadAchievements() {
            self.unlockedAchievements = loadedAchievements
        }
    }
    
    /// Проверить, получено ли достижение
    func isAchievementUnlocked(_ achievement: Achievement) -> Bool {
        return unlockedAchievements.contains(achievement.id)
    }
    
    /// Разблокировать достижение
    func unlockAchievement(_ achievement: Achievement) {
        // Если достижение уже разблокировано, ничего не делаем
        guard !isAchievementUnlocked(achievement) else { return }
        
        // Разблокируем достижение
        unlockedAchievements.insert(achievement.id)
        
        // Здесь можно добавить логику для показа уведомления
    }
    
    /// Проверка условий для получения достижений
    func checkAchievements(completedLevelId: Int? = nil) {
        // Проверка FirstNavigation - завершение первого уровня
        if let levelId = completedLevelId, levelId == 1 {
            unlockAchievement(.firstnavigation)
        }
        
        // Получаем сервис прогресса для проверки количества завершенных уровней
        let progressService = UserProgressService.shared
        let unlockedLevelCount = progressService.userProgress.unlockedLevelIds.count
        
        // Проверка NavalStrategist - завершение 5 уровней
        if unlockedLevelCount >= 5 {
            unlockAchievement(.navalstrategist)
        }
        
        // Проверка PortMaster - завершение 10 уровней
        if unlockedLevelCount >= 10 {
            unlockAchievement(.portmaster)
        }
        
        // Проверка PreciseCalculation и KingOfThePort будет выполняться
        // в другом месте, так как требует отслеживания столкновений
    }
    
    /// Проверка достижений за прохождение без столкновений
    func checkCollisionFreeAchievements(completedLevelsWithoutCollision: Int, allLevelsCompleted: Bool) {
        // PreciseCalculation - завершение 5 уровней без столкновений
        if completedLevelsWithoutCollision >= 5 {
            unlockAchievement(.precisecalculation)
        }
        
        // KingOfThePort - завершение всех уровней без столкновений
        if allLevelsCompleted {
            unlockAchievement(.kingoftheport)
        }
    }
    
    /// Сбросить все достижения (для тестирования)
    func resetAchievements() {
        unlockedAchievements.removeAll()
    }
    
    // MARK: - Private Methods
    
    /// Сохранить достижения в хранилище
    private func saveAchievements() {
        UserDefaults.standard.set(Array(unlockedAchievements), forKey: achievementsKey)
    }
    
    /// Загрузить достижения из хранилища
    private func loadAchievements() -> Set<Int>? {
        guard let savedData = UserDefaults.standard.array(forKey: achievementsKey) as? [Int] else {
            return nil
        }
        return Set(savedData)
    }
}
