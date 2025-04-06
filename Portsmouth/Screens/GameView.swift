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
                topBar
                
                Spacer()
            }
            
            // Оверлей паузы
            if gameViewModel.gameState == .paused {
                pauseOverlay
            }
            
            // Оверлей победы
            if gameViewModel.gameState == .victory {
                victoryOverlay
            }
            
            // Оверлей поражения
            if gameViewModel.gameState == .gameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            setupLevelViewModel()
        }
    }
    
    // MARK: - Компоненты интерфейса
    
    private var topBar: some View {
        HStack {
            // Кнопка меню (пауза)
            Button(action: {
                gameViewModel.pauseGame()
            }) {
                Image(systemName: "pause.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Счетчик монет
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.yellow)
                Text("\(gameViewModel.coins)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .padding(8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
            
            Spacer()
            
            // Кнопка перезапуска
            Button(action: {
                levelViewModel.restartLevel()
            }) {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(Circle())
            }
        }
        .padding()
    }
    
    private var pauseOverlay: some View {
        ZStack {
            // Затемненный фон
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Диалог паузы
            VStack(spacing: 20) {
                Text("Пауза")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Кнопка продолжения
                Button(action: {
                    gameViewModel.resumeGame()
                }) {
                    Text("Продолжить")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Кнопка возврата в меню
                Button(action: {
                    gameViewModel.returnToMainMenu()
                }) {
                    Text("В меню")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private var victoryOverlay: some View {
        ZStack {
            // Затемненный фон
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Диалог победы
            VStack(spacing: 20) {
                Text("Уровень пройден!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                    
                    Text("+100")
                        .font(.title)
                        .foregroundColor(.yellow)
                        .fontWeight(.bold)
                }
                
                // Кнопка следующего уровня
                Button(action: {
                    gameViewModel.goToNextLevel()
                }) {
                    Text("Следующий уровень")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                
                // Кнопка возврата в меню
                Button(action: {
                    gameViewModel.returnToMainMenu()
                }) {
                    Text("В меню")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private var gameOverOverlay: some View {
        ZStack {
            // Затемненный фон
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Диалог поражения
            VStack(spacing: 20) {
                Text("Game Over")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Корабли столкнулись!")
                    .font(.title2)
                    .foregroundColor(.red)
                
                // Кнопка перезапуска
                Button(action: {
                    levelViewModel.restartLevel()
                    gameViewModel.restartLevel()
                }) {
                    Text("Попробовать снова")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Кнопка возврата в меню
                Button(action: {
                    gameViewModel.returnToMainMenu()
                }) {
                    Text("В меню")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
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
        newScene.scaleMode = .aspectFit
        newScene.levelViewModel = levelViewModel
        
        // Сохраняем сцену
        scene = newScene
        
        return newScene
    }
    
    // MARK: - Настройка ViewModel
    
    private func setupLevelViewModel() {
        // Установка делегата - теперь без приведения к any, так как протокол не ограничен классами
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
        // Пересоздаем сцену для перезапуска
        scene = nil
    }
}

#Preview {
    GameView(gameViewModel: GameViewModel())
}
