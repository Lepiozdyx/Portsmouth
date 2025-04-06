import SwiftUI

struct ContentView: View {
    // MARK: - ViewModel
    
    @StateObject private var gameViewModel = GameViewModel()
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                // Отображаем соответствующий экран в зависимости от состояния игры
                switch gameViewModel.gameState {
                case .menu:
                    MainMenuView(gameViewModel: gameViewModel)
                    
                case .levelSelect:
                    LevelSelectView(gameViewModel: gameViewModel)
                    
                case .playing, .paused, .victory, .gameOver:
                    GameView(gameViewModel: gameViewModel)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    ContentView()
}
