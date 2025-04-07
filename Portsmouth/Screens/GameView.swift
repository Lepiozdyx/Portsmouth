import SwiftUI
import SpriteKit

struct GameView: View {
    // MARK: - ViewModel
    
    @ObservedObject var gameViewModel: GameViewModel
    @StateObject private var levelViewModel: LevelViewModel
    
    // MARK: - Состояние
    
    @State private var scene: GameScene?
    @State private var safeAreaInsets: EdgeInsets = EdgeInsets()
    @State private var needsReset: Bool = false
    
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
                if needsReset {
                    // Временный контейнер, пока сцена сбрасывается
                    Color.blue.opacity(0.3)
                        .onAppear {
                            // Сбрасываем сцену и флаг
                            self.scene = nil
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.needsReset = false
                            }
                        }
                } else {
                    SpriteView(scene: getGameScene(size: geometry.size, safeArea: geometry.safeAreaInsets))
                        .edgesIgnoringSafeArea(.all)
                }
                
                // Верхний бар с кнопками
                VStack {
                    TopBarView(
                        coins: gameViewModel.coins,
                        returnToMenuAction: {
                            // Очищаем сцену перед выходом в меню
                            scene = nil
                            gameViewModel.returnToMainMenu()
                        },
                        restartAction: {
                            // Сбрасываем сцену и рестартим уровень
                            resetGameScene()
                            levelViewModel.restartLevel()
                        }
                    )
                    .padding([.horizontal, .top])
                    
                    Spacer()
                }
                
                // Оверлей победы
                if gameViewModel.gameState == .victory {
                    VictoryOverlayView(
                        nextLevelAction: {
                            resetGameScene()
                            gameViewModel.goToNextLevel()
                        },
                        returnToMenuAction: {
                            // Очищаем сцену перед выходом в меню
                            scene = nil
                            gameViewModel.returnToMainMenu()
                        }
                    )
                }
                
                // Оверлей поражения
                if gameViewModel.gameState == .gameOver {
                    GameOverOverlayView(
                        retryAction: {
                            // Сбрасываем сцену для перезапуска
                            resetGameScene()
                            gameViewModel.restartLevel()
                        },
                        returnToMenuAction: {
                            // Очищаем сцену перед выходом в меню
                            scene = nil
                            gameViewModel.returnToMainMenu()
                        }
                    )
                }
            }
        }
        .onAppear {
            setupLevelViewModel()
        }
        .onDisappear {
            // Очищаем сцену при исчезновении вью для предотвращения утечек памяти
            scene = nil
        }
    }
    
    // MARK: - Обновление размеров
    
    private func updateGameDimensions(size: CGSize, safeArea: EdgeInsets) {
        self.safeAreaInsets = safeArea
        
        // Если у нас уже есть сцена, обновим её размеры
        scene?.updateSceneSize(size: size, safeArea: safeArea)
    }
    
    // MARK: - Сброс игровой сцены
    
    private func resetGameScene() {
        scene = nil
        needsReset = true
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
        // Сбрасываем сцену при перезапуске уровня
        resetGameScene()
    }
}   

#Preview {
    GameView(gameViewModel: GameViewModel())
}
