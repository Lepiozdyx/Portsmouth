//
//  Player.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import Foundation

struct Player: Codable {
    var coins: Int = 0
    var completedLevels: [Int: Bool] = [:]  // Ключ - id уровня, значение - завершен или нет
    var unlockedShipTypes: Set<String> = [ShipType.cargo.rawValue]  // Начальный тип корабля
    var unlockedBackgrounds: Set<String> = [BackgroundType.classic.rawValue]  // Начальный фон
    var currentShipType: String = ShipType.cargo.rawValue  // Текущий выбранный тип корабля
    var currentBackground: String = BackgroundType.classic.rawValue  // Текущий выбранный фон
    var achievementsUnlocked: [String: Bool] = [:]  // Ключ - тип достижения, значение - разблокировано или нет
    var achievementsRewardClaimed: [String: Bool] = [:]  // Ключ - тип достижения, значение - награда получена или нет
    
    // Преобразования для совместимости с Codable
    var currentShipTypeEnum: ShipType {
        return ShipType(rawValue: currentShipType) ?? .cargo
    }
    
    var currentBackgroundEnum: BackgroundType {
        return BackgroundType(rawValue: currentBackground) ?? .classic
    }
    
    var unlockedShipTypesEnum: Set<ShipType> {
        Set(unlockedShipTypes.compactMap { ShipType(rawValue: $0) })
    }
    
    var unlockedBackgroundsEnum: Set<BackgroundType> {
        Set(unlockedBackgrounds.compactMap { BackgroundType(rawValue: $0) })
    }
    
    // Проверка, разблокирован ли тип корабля
    func isShipTypeUnlocked(_ type: ShipType) -> Bool {
        return unlockedShipTypes.contains(type.rawValue)
    }
    
    // Проверка, разблокирован ли фон
    func isBackgroundUnlocked(_ type: BackgroundType) -> Bool {
        return unlockedBackgrounds.contains(type.rawValue)
    }
    
    // Проверка, получена ли награда за достижение
    func isAchievementRewardClaimed(_ type: AchievementType) -> Bool {
        return achievementsRewardClaimed[type.rawValue] == true
    }
    
    // Проверка, разблокировано ли достижение
    func isAchievementUnlocked(_ type: AchievementType) -> Bool {
        return achievementsUnlocked[type.rawValue] == true
    }
    
    // Разблокировка достижения
    mutating func unlockAchievement(_ type: AchievementType) {
        achievementsUnlocked[type.rawValue] = true
    }
    
    // Получение награды за достижение
    mutating func claimAchievementReward(_ type: AchievementType) {
        if isAchievementUnlocked(type) && !isAchievementRewardClaimed(type) {
            coins += type.reward
            achievementsRewardClaimed[type.rawValue] = true
        }
    }
}
