import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    // Создаем игровую сцену
    var gameScene: GameScene
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        
        // Создаем сцену с фиксированными размерами
        let scene = GameScene(size: CGSize(width: 320, height: 480))
        scene.scaleMode = .aspectFit
        scene.viewModel = viewModel
        
        // Включаем опции отладки
        scene.view?.showsFPS = true
        scene.view?.showsNodeCount = true
        
        self.gameScene = scene
        
        // Сбрасываем состояние игры при инициализации
        viewModel.resetGameState()
    }
    
    var body: some View {
        ZStack {
            // SpriteView для отображения SpriteKit сцены
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(Color.blue.opacity(0.1))
                .border(Color.red, width: 1) // Индикатор границы для отладки
            
            // Простой UI
            VStack {
                // Верхняя панель
                HStack {
                    // Кнопка назад с хорошо видимой рамкой
                    Button(action: {
                        viewModel.goToMenu()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(25)
                    
                    Spacer()
                    
                    // Счет с увеличенным размером для лучшей видимости
                    Text("Счет: \(viewModel.player.coins)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(10)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    
                    Spacer()
                    
                    // Кнопка перезапуска с хорошо видимой рамкой
                    Button(action: {
                        gameScene.resetScene()
                        viewModel.resetGameState()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "arrow.clockwise")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(25)
                }
                .padding()
                
                // Добавляем текст с инструкцией для пользователя
                Text("Нажмите на корабль, чтобы начать")
                    .font(.headline)
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                
                Spacer()
            }
            
            // Модальное окно окончания уровня
            if viewModel.isLevelCompleted {
                VictoryView(viewModel: viewModel)
            }
            
            // Модальное окно проигрыша
            if viewModel.isGameOver && viewModel.gameState == .gameOver {
                GameOverView(viewModel: viewModel, resetAction: {
                    gameScene.resetScene()
                })
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            print("GameView появилась")
            // Сбрасываем состояние при появлении экрана
            viewModel.resetGameState()
            
            // Перезапускаем сцену с небольшой задержкой
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("Сбрасываем сцену")
                gameScene.resetScene()
            }
        }
    }
}

// Представление победы
struct VictoryView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Уровень пройден!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("+100 монет")
                    .font(.headline)
                    .foregroundColor(.yellow)
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.goToMenu()
                    }) {
                        Text("В меню")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 120)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        viewModel.nextLevel()
                    }) {
                        Text("Дальше")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 120)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(20)
        }
    }
}

// Представление проигрыша
struct GameOverView: View {
    @ObservedObject var viewModel: GameViewModel
    let resetAction: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Столкновение!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                
                Text("Выберите другой порядок запуска кораблей")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.goToMenu()
                    }) {
                        Text("В меню")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 120)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        resetAction()
                        viewModel.restartLevel()
                    }) {
                        Text("Заново")
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 120)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.gray)
            .cornerRadius(20)
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}
