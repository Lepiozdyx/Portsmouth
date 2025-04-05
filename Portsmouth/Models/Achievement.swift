//
//  Achievement.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import Foundation

enum AchievementType: String, CaseIterable {
    case firstNavigation = "Первая навигация"
    case portMaster = "Портовый мастер"
    case shippingStrategist = "Судоходный стратег"
    case navigationGenius = "Гений навигации"
    case preciseCalculation = "Точный расчёт"
    case containerTycoon = "Контейнерный магнат"
    case portKing = "Король порта"
    
    var description: String {
        switch self {
        case .firstNavigation:
            return "Завершить первый уровень."
        case .portMaster:
            return "Пройти 10 уровней."
        case .shippingStrategist:
            return "Развести 5 кораблей подряд без ошибок."
        case .navigationGenius:
            return "Завершить 20 уровней."
        case .preciseCalculation:
            return "Вывести два корабля через один узкий проход без задержек."
        case .containerTycoon:
            return "Собрать 1000 монет за всё время игры."
        case .portKing:
            return "Завершить все уровни без единого столкновения."
        }
    }
    
    var reward: Int {
        return 10
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let type: AchievementType
    var isUnlocked: Bool
    var isRewardClaimed: Bool
}
