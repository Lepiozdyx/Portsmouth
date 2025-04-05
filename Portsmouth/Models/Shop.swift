//
//  Shop.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import Foundation

enum ShopItemType: Equatable {
    case shipSkin(ShipType)
    case background(BackgroundType)
    
    var price: Int {
        return 100 // все предметы стоят 100 монет
    }
    
    var displayName: String {
        switch self {
        case .shipSkin(let type):
            return type.displayName
        case .background(let type):
            return type.displayName
        }
    }
}

struct ShopItem: Identifiable {
    let id = UUID()
    let itemType: ShopItemType
    var isUnlocked: Bool
    
    var price: Int {
        return itemType.price
    }
    
    var displayName: String {
        return itemType.displayName
    }
}
