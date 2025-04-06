import Foundation

/// Сервис для управления прогрессом пользователя
class UserProgressService {
    // Синглтон для доступа по всему приложению
    static let shared = UserProgressService()
    
    // Ключ для хранения прогресса в UserDefaults
    private let userProgressKey = "com.riversportsmouth.userProgress"
    
    // Текущий прогресс пользователя
    private(set) var userProgress: UserProgress {
        didSet {
            saveProgress()
        }
    }
    
    private init() {
        // Сначала инициализируем со значением по умолчанию
        self.userProgress = UserProgress()
        
        // Затем загружаем прогресс из хранилища, если он есть
        if let loadedProgress = loadProgress() {
            self.userProgress = loadedProgress
        }
    }
    
    /// Добавить монеты к балансу пользователя
    func addCoins(_ amount: Int) {
        userProgress.addCoins(amount)
    }
    
    /// Разблокировать уровень
    func unlockLevel(id: Int) {
        userProgress.unlockLevel(id: id)
    }
    
    /// Проверить, разблокирован ли уровень
    func isLevelUnlocked(id: Int) -> Bool {
        return userProgress.isLevelUnlocked(id: id)
    }
    
    /// Получить текущее количество монет
    func getCoins() -> Int {
        return userProgress.coins
    }
    
    /// Сохранить прогресс в хранилище
    private func saveProgress() {
        if let encodedProgress = try? JSONEncoder().encode(userProgress) {
            UserDefaults.standard.set(encodedProgress, forKey: userProgressKey)
        }
    }
    
    /// Загрузить прогресс из хранилища
    private func loadProgress() -> UserProgress? {
        guard let savedData = UserDefaults.standard.data(forKey: userProgressKey),
              let decodedProgress = try? JSONDecoder().decode(UserProgress.self, from: savedData) else {
            return nil
        }
        return decodedProgress
    }
    
    /// Сбросить прогресс (для тестирования)
    func resetProgress() {
        userProgress = UserProgress()
    }
}
