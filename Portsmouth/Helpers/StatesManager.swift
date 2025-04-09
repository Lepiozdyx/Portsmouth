import Foundation

enum States {
    case starting
    case web
    case content
}

@MainActor
final class StatesManager: ObservableObject {
    
    @Published private(set) var state: States = .starting
    
    let nwManager: NetworkManager
    
    init(nwManager: NetworkManager = NetworkManager()) {
        self.nwManager = nwManager
    }
    
    func stateCheck() {
        Task {
            if nwManager.targetURL != nil {
                state = .web
                return
            }
            
            do {
                if try await nwManager.checkInitialURL() {
                    state = .web
                } else {
                    state = .content
                }
            } catch {
                state = .content
            }
        }
    }
}
