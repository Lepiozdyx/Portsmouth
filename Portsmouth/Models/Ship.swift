//
//  Ship.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import Foundation

enum TurnDirection {
    case left
    case right
    case straight
    case reverse
}

enum ShipType: String, CaseIterable {
    case cargo     // Обычные грузовые суда
    case ferry     // Паромы
    case sailboat  // Парусники
    case container // Современные контейнеровозы
    
    var displayName: String {
        switch self {
        case .cargo: return "Обычные грузовые суда"
        case .ferry: return "Паромы"
        case .sailboat: return "Парусники"
        case .container: return "Современные контейнеровозы"
        }
    }
}

struct Ship: Identifiable, Equatable {
    let id = UUID()
    let type: ShipType
    let turnPattern: TurnDirection  // Паттерн поворота на перекрестке
    let speed: CGFloat              // Скорость движения
    var position: CGPoint           // Начальная позиция
    var rotation: CGFloat           // Начальная ротация (в радианах)
    var isMoving: Bool = false      // Статус движения
    var intersectionsPassed: Int = 0 // Количество пройденных перекрестков
    
    static func == (lhs: Ship, rhs: Ship) -> Bool {
        return lhs.id == rhs.id
    }
}
