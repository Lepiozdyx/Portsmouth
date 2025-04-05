//
//  Level.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import Foundation
import SpriteKit

enum BackgroundType: String, CaseIterable {
    case classic   // Классический порт
    case sunset    // Закатный порт
    case night     // Ночной город
    case snow      // Порт в снегу
    
    var displayName: String {
        switch self {
        case .classic: return "Классический порт"
        case .sunset: return "Закатный порт"
        case .night: return "Ночной город"
        case .snow: return "Порт в снегу"
        }
    }
}

struct Level: Identifiable, Equatable {
    let id: Int
    let name: String
    let ships: [Ship]
    let backgroundType: BackgroundType
    var isUnlocked: Bool
    
    // Вспомогательные свойства для создания уровней
    var waterPaths: [CGPath] = []
    var intersections: [Intersection] = []
    
    static func == (lhs: Level, rhs: Level) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Intersection: Identifiable {
    let id = UUID()
    let position: CGPoint
}
