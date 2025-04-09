import SwiftUI

struct RootView: View {
    
    @StateObject private var state = StatesManager()
    
    var body: some View {
        Group {
            switch state.state {
            case .starting:
                LoadingScreenView()
            case .web:
                if let url = state.nwManager.targetURL {
                    WebViewManager(url: url, webManager: state.nwManager)
                } else {
                    WebViewManager(url: NetworkManager.initialURL, webManager: state.nwManager)
                }
            case .content:
                ContentView()
            }
        }
        .onAppear {
            state.stateCheck()
        }
    }
}

#Preview {
    RootView()
}
