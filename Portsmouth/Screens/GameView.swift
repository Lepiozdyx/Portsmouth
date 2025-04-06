import SwiftUI
import SpriteKit

struct GameView: View {
    // MARK: - ViewModel
    
    @ObservedObject var gameViewModel: GameViewModel
    @StateObject private var levelViewModel: LevelViewModel
    
    // MARK: - Состояние
    
    @State private var scene: GameScene?
    
    // MARK: - Инициализация
    
    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        
        // Инициализируем LevelViewModel для текущего уровня
        let level = gameViewModel.currentLevel ?? LevelManager.shared.getTestLevel()
        _levelViewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }
    
    // MARK: - Представление
    
    var body: some View {
        ZStack {
            // Основное игровое представление
            GeometryReader { geometry in
                SpriteView(scene: getGameScene(size: geometry.size))
                    .ignoresSafeArea()
            }
            
            // Верхний бар с кнопками
            VStack {
                TopBarView(
                    coins: gameViewModel.coins,
                    pauseAction: gameViewModel.pauseGame,
                    restartAction: gameViewModel.restartLevel
                )
                
                Spacer()
            }
            .padding([.top, .horizontal])
            
            // Оверлей паузы
            if gameViewModel.gameState == .paused {
                PauseOverlayView(
                    resumeAction: gameViewModel.resumeGame,
                    returnToMenuAction: gameViewModel.returnToMainMenu
                )
            }
            
            // Оверлей победы
            if gameViewModel.gameState == .victory {
                VictoryOverlayView(
                    nextLevelAction: gameViewModel.goToNextLevel,
                    returnToMenuAction: gameViewModel.returnToMainMenu
                )
            }
            
            // Оверлей поражения
            if gameViewModel.gameState == .gameOver {
                GameOverOverlayView(
                    retryAction: {
                        levelViewModel.restartLevel()
                        gameViewModel.restartLevel()
                    },
                    returnToMenuAction: gameViewModel.returnToMainMenu
                )
            }
        }
        .onAppear {
            setupLevelViewModel()
        }
    }
    
    // MARK: - SpriteKit
    
    private func getGameScene(size: CGSize) -> SKScene {
        if let existingScene = scene {
            return existingScene
        }
        
        // Создаем новую сцену
        let newScene = GameScene()
        newScene.size = size
        newScene.scaleMode = .aspectFill
        newScene.levelViewModel = levelViewModel
        
        // Сохраняем сцену
        scene = newScene
        
        return newScene
    }
    
    // MARK: - Настройка ViewModel
    
    private func setupLevelViewModel() {
        levelViewModel.delegate = self
    }
}

// MARK: - Расширение для делегата LevelViewModel

extension GameView: LevelViewModelDelegate {
    func levelCompleted() {
        gameViewModel.completeLevel()
    }
    
    func levelFailed() {
        gameViewModel.gameover()
    }
    
    func levelRestarted() {
        scene = nil
    }
}

#Preview {
    GameView(gameViewModel: GameViewModel())
}
