import SwiftUI

struct ContentView: View {
    // MARK: - ViewModel
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var settings = SettingsManager.shared
    @StateObject private var gameViewModel = GameViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                switch gameViewModel.gameState {
                case .menu:
                    MainMenuView(gameViewModel: gameViewModel)
                    
                case .levelSelect:
                    LevelSelectView(gameViewModel: gameViewModel)
                    
                case .playing, .victory, .gameOver:
                    // Уникальный ID через UUID для принудительного пересоздания GameView
                    // при изменениях состояния игры
                    GameView(gameViewModel: gameViewModel)
                        .id(gameViewModel.currentLevel?.id ?? 0)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if settings.isMusicOn {
                settings.playMusic()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                settings.playMusic()
            case .background, .inactive:
                settings.stopMusic()
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    ContentView()
}
