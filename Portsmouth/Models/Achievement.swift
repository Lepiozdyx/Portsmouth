import Foundation

enum Achievement: Int, CaseIterable, Identifiable {
    
    var id: Int { self.rawValue }
    
    case firstnavigation = 0
    case kingoftheport
    case navalstrategist
    case portmaster
    case precisecalculation
    
    var imageName: String {
        switch self {
        case .firstnavigation:
            "firstnavigation"
        case .kingoftheport:
            "kingoftheport"
        case .navalstrategist:
            "navalstrategist"
        case .portmaster:
            "portmaster"
        case .precisecalculation:
            "precisecalculation"
        }
    }
    
    var title: String {
        switch self {
        case .firstnavigation:
            "First Navigation"
        case .kingoftheport:
            "King of the Port"
        case .navalstrategist:
            "Naval Strategist"
        case .portmaster:
            "Port Master"
        case .precisecalculation:
            "Precise Calculation"
        }
    }
    
    var description: String {
        switch self {
        case .firstnavigation:
            "Complete the first level"
        case .kingoftheport:
            "Complete all levels without a single collision"
        case .navalstrategist:
            "Complete 5 levels"
        case .portmaster:
            "Complete 10 levels"
        case .precisecalculation:
            "Complete 5 levels without a single collision"
        }
    }
}
