import SwiftUI
import SpriteKit

struct GameView: View {
    // MARK: - ViewModel
    
    @ObservedObject var gameViewModel: GameViewModel
    @StateObject private var levelViewModel: LevelViewModel
    
    // MARK: - Состояние
    
    @State private var scene: GameScene?
    @State private var safeAreaInsets: EdgeInsets = EdgeInsets()
    
    // MARK: - Инициализация
    
    init(gameViewModel: GameViewModel) {
        self.gameViewModel = gameViewModel
        
        // Инициализируем LevelViewModel для текущего уровня
        let level = gameViewModel.currentLevel ?? LevelManager.shared.getTestLevel()
        _levelViewModel = StateObject(wrappedValue: LevelViewModel(level: level))
    }
    
    // MARK: - Представление
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Извлекаем размеры экрана и safeArea
                Color.clear
                    .onAppear {
                        updateGameDimensions(size: geometry.size, safeArea: geometry.safeAreaInsets)
                    }
                    .onChange(of: geometry.size) { newSize in
                        updateGameDimensions(size: newSize, safeArea: geometry.safeAreaInsets)
                    }
                
                // Основное игровое представление
                SpriteView(scene: getGameScene(size: geometry.size, safeArea: geometry.safeAreaInsets))
                    .edgesIgnoringSafeArea(.all)
                
                // Верхний бар с кнопками
                VStack {
                    TopBarView(
                        coins: gameViewModel.coins,
                        returnToMenuAction: gameViewModel.returnToMainMenu,
                        restartAction: gameViewModel.restartLevel
                    )
                    .padding([.horizontal, .top])
                    
                    Spacer()
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
        }
        .onAppear {
            setupLevelViewModel()
        }
    }
    
    // MARK: - Обновление размеров
    
    private func updateGameDimensions(size: CGSize, safeArea: EdgeInsets) {
        self.safeAreaInsets = safeArea
        
        // Если у нас уже есть сцена, обновим её размеры
        scene?.updateSceneSize(size: size, safeArea: safeArea)
    }
    
    // MARK: - SpriteKit
    
    private func getGameScene(size: CGSize, safeArea: EdgeInsets) -> SKScene {
        if let existingScene = scene {
            return existingScene
        }
        
        // Создаем новую сцену
        let newScene = GameScene()
        newScene.size = size
        newScene.scaleMode = .resizeFill  // Используем resizeFill вместо aspectFill
        newScene.levelViewModel = levelViewModel
        
        // Передаем информацию о размерах экрана и безопасных областях
        newScene.updateSceneSize(size: size, safeArea: safeArea)
        
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
