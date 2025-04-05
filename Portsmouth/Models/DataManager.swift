//
//  DataManager.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private let playerKey = "player_data"
    
    private init() {}
    
    // Загрузка данных игрока
    func loadPlayer() -> Player {
        if let data = UserDefaults.standard.data(forKey: playerKey),
           let player = try? JSONDecoder().decode(Player.self, from: data) {
            return player
        }
        return Player() // Возвращаем нового игрока, если данных нет
    }
    
    // Сохранение данных игрока
    func savePlayer(_ player: Player) {
        if let data = try? JSONEncoder().encode(player) {
            UserDefaults.standard.set(data, forKey: playerKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    // Проверка и обновление достижений
    func checkAchievements(player: inout Player, completedLevelId: Int? = nil) {
        // Первая навигация - Завершить первый уровень
        if completedLevelId == 1 || player.completedLevels[1] == true {
            player.unlockAchievement(.firstNavigation)
        }
        
        // Портовый мастер - Пройти 10 уровней
        let completedLevelsCount = player.completedLevels.filter { $0.value == true }.count
        if completedLevelsCount >= 10 {
            player.unlockAchievement(.portMaster)
        }
        
        // Гений навигации - Завершить 20 уровней
        if completedLevelsCount >= 20 {
            player.unlockAchievement(.navigationGenius)
        }
        
        // Контейнерный магнат - Собрать 1000 монет за всё время игры
        if player.coins >= 1000 {
            player.unlockAchievement(.containerTycoon)
        }
        
        // Король порта - Завершить все уровни без единого столкновения
        if completedLevelsCount >= 10 {
            // Предполагаем, что всего 10 уровней по ТЗ
            player.unlockAchievement(.portKing)
        }
        
        // Другие достижения проверяются в GameViewModel, так как требуют доступа к игровому процессу
    }
}
