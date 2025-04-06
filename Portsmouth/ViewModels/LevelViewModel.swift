import Foundation
import Combine
import SpriteKit

/// Протокол делегата для взаимодействия с GameViewModel
/// Убираем ограничение AnyObject, чтобы структуры SwiftUI могли соответствовать этому протоколу
protocol LevelViewModelDelegate {
    /// Уровень успешно пройден
    func levelCompleted()
    
    /// Уровень не пройден (столкновение кораблей)
    func levelFailed()
    
    /// Уровень перезапущен
    func levelRestarted()
}

/// ViewModel для управления конкретным уровнем игры
class LevelViewModel: ObservableObject {
    // MARK: - Published свойства
    
    /// Текущий уровень
    @Published var level: LevelModel
    
    /// Количество оставшихся кораблей
    @Published var remainingShips: Int
    
    /// Флаг, указывающий на успешное прохождение уровня
    @Published var isLevelCompleted: Bool = false
    
    /// Флаг, указывающий на поражение
    @Published var isGameOver: Bool = false
    
    // MARK: - Делегат для обработки событий уровня
    
    // Поскольку мы убрали ограничение AnyObject из протокола,
    // мы не можем использовать weak reference.
    // Вместо этого используем обычную переменную.
    var delegate: LevelViewModelDelegate?
    
    // MARK: - Инициализация
    
    init(level: LevelModel) {
        self.level = level
        self.remainingShips = level.ships.count
    }
    
    // MARK: - Методы управления кораблями
    
    /// Старт движения корабля
    func startShipMovement(shipId: UUID) {
        // Этот метод будет вызываться из GameScene
        // Обновление состояния модели осуществляется в самой сцене
    }
    
    /// Корабль успешно завершил путь
    func shipCompletedPath() {
        remainingShips -= 1
        
        // Проверяем, завершен ли уровень
        if remainingShips <= 0 {
            completeLevel()
        }
    }
    
    /// Столкновение кораблей
    func shipCollision() {
        isGameOver = true
        delegate?.levelFailed()
    }
    
    // MARK: - Методы управления уровнем
    
    /// Перезапустить уровень
    func restartLevel() {
        remainingShips = level.ships.count
        isLevelCompleted = false
        isGameOver = false
        
        // Уведомляем делегата о необходимости перезапуска уровня
        delegate?.levelRestarted()
    }
    
    /// Уровень успешно пройден
    private func completeLevel() {
        isLevelCompleted = true
        delegate?.levelCompleted()
    }
    
    // MARK: - Вспомогательные методы
    
    /// Получить размер игрового поля в точках
    func getGridSizeInPoints() -> CGSize {
        let width = CGFloat(level.gridSettings.width) * level.gridSettings.cellSize
        let height = CGFloat(level.gridSettings.height) * level.gridSettings.cellSize
        return CGSize(width: width, height: height)
    }
    
    /// Преобразовать позицию сетки в координаты сцены
    func gridPositionToScenePosition(_ gridPosition: GridPosition) -> CGPoint {
        return gridPosition.toPoint(cellSize: level.gridSettings.cellSize)
    }
    
    /// Обновить размер ячейки в модели
    func updateCellSize(_ newCellSize: CGFloat) {
        // Создаем новые настройки сетки с обновленным размером ячейки
        let newGridSettings = GridSettings(
            width: level.gridSettings.width,
            height: level.gridSettings.height,
            cellSize: newCellSize
        )
        
        // Обновляем модель уровня
        level = LevelModel(
            id: level.id,
            name: level.name,
            gridSettings: newGridSettings,
            ships: level.ships,
            intersections: level.intersections,
            obstacles: level.obstacles
        )
    }
}
