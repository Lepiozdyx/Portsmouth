import Foundation

class CollisionTrackerService {
    static let shared = CollisionTrackerService()
    
    private let collisionFreeKey = "com.riversportsmouth.collisionFreeLevels"
    
    private(set) var collisionFreeLevelIds: Set<Int> {
        didSet {
            saveCollisionFreeLevels()
            updateAchievements()
        }
    }
    
    private init() {
        self.collisionFreeLevelIds = Set<Int>()
        
        if let loadedData = loadCollisionFreeLevels() {
            self.collisionFreeLevelIds = loadedData
        }
    }
    
    /// Отметить уровень как пройденный без столкновений
    func markLevelAsCollisionFree(levelId: Int) {
        collisionFreeLevelIds.insert(levelId)
    }
    
    /// Отметить уровень как пройденный со столкновением
    func markLevelWithCollision(levelId: Int) {
        collisionFreeLevelIds.remove(levelId)
    }
    
    /// Проверить, пройден ли уровень без столкновений
    func isLevelCompletedWithoutCollision(levelId: Int) -> Bool {
        return collisionFreeLevelIds.contains(levelId)
    }
    
    /// Получить количество уровней, пройденных без столкновений
    func getCollisionFreeLevelsCount() -> Int {
        return collisionFreeLevelIds.count
    }
    
    /// Проверить, все ли уровни пройдены без столкновений
    func areAllLevelsCompletedWithoutCollision() -> Bool {
        let progressService = UserProgressService.shared
        let allUnlockedLevels = progressService.userProgress.unlockedLevelIds
        
        // Проверяем, что все разблокированные уровни пройдены без столкновений
        // и что пройдены все 9 уровней
        return allUnlockedLevels.isSubset(of: collisionFreeLevelIds) &&
               allUnlockedLevels.count >= 9
    }
    
    /// Обновить достижения на основе текущего прогресса
    private func updateAchievements() {
        let achievementService = AchievementService.shared
        achievementService.checkCollisionFreeAchievements(
            completedLevelsWithoutCollision: getCollisionFreeLevelsCount(),
            allLevelsCompleted: areAllLevelsCompletedWithoutCollision()
        )
    }
    
    /// Сбросить все данные (для тестирования)
    func resetData() {
        collisionFreeLevelIds.removeAll()
    }
    
    // MARK: - Private Methods
    
    /// Сохранить данные в хранилище
    private func saveCollisionFreeLevels() {
        UserDefaults.standard.set(Array(collisionFreeLevelIds), forKey: collisionFreeKey)
    }
    
    /// Загрузить данные из хранилища
    private func loadCollisionFreeLevels() -> Set<Int>? {
        guard let savedData = UserDefaults.standard.array(forKey: collisionFreeKey) as? [Int] else {
            return nil
        }
        return Set(savedData)
    }
}
