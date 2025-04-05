import SwiftUI
import SpriteKit

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var isMenuVisible = false
    
    // Создаем игровую сцену
    var gameScene: GameScene
    
    init(viewModel: GameViewModel) {
        self.viewModel = viewModel
        
        // Создаем сцену с фиксированными размерами
        let scene = GameScene(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.8))
        scene.scaleMode = .aspectFill
        scene.viewModel = viewModel
        
        // Отключаем опции отладки для релиза
        #if DEBUG
        scene.view?.showsFPS = true
        scene.view?.showsNodeCount = true
        #endif
        
        self.gameScene = scene
        
        // Сбрасываем состояние игры при инициализации
        viewModel.resetGameState()
    }
    
    var body: some View {
        ZStack {
            // SpriteView для отображения SpriteKit сцены
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // UI поверх игровой сцены
            VStack {
                // Верхняя панель
                HStack {
                    // Кнопка назад
                    Button(action: {
                        isMenuVisible = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: 44, height: 44)
                                .shadow(radius: 2)
                            
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Spacer()
                    
                    // Счет с фоном и тенью
                    HStack(spacing: 4) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.yellow)
                        
                        Text("\(viewModel.player.coins)")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.8))
                            .shadow(radius: 2)
                    )
                    
                    Spacer()
                    
                    // Кнопка перезапуска
                    Button(action: {
                        gameScene.resetScene()
                        viewModel.resetGameState()
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.8))
                                .frame(width: 44, height: 44)
                                .shadow(radius: 2)
                            
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
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
            
            // Модальное окно возврата в меню
            if isMenuVisible {
                MenuConfirmView(
                    dismiss: { isMenuVisible = false },
                    goToMenu: { viewModel.goToMenu() }
                )
            }
        }
        .navigationBarHidden(true)
        .statusBar(hidden: true)
        .onAppear {
            // Сбрасываем состояние при появлении экрана
            viewModel.resetGameState()
            
            // Перезапускаем сцену с небольшой задержкой
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
            
            VStack(spacing: 24) {
                // Изображение трофея
                Image(systemName: "trophy.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.yellow)
                    .shadow(color: .orange, radius: 10, x: 0, y: 0)
                
                Text("Уровень пройден!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 8) {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title2)
                        .foregroundColor(.yellow)
                    
                    Text("+100")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.yellow)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(UIColor.systemBackground).opacity(0.2))
                )
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.goToMenu()
                    }) {
                        HStack {
                            Image(systemName: "house")
                            Text("В меню")
                        }
                        .font(.headline)
                        .padding()
                        .frame(width: 130)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                        .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        viewModel.nextLevel()
                    }) {
                        HStack {
                            Image(systemName: "arrow.right")
                            Text("Дальше")
                        }
                        .font(.headline)
                        .padding()
                        .frame(width: 130)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.green)
                        )
                        .foregroundColor(.white)
                    }
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemGray6))
                    .shadow(radius: 10)
            )
            .padding(.horizontal, 32)
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
            
            VStack(spacing: 24) {
                // Изображение столкновения
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.red)
                    .shadow(color: .orange, radius: 5, x: 0, y: 0)
                
                Text("Столкновение!")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Выберите другой порядок запуска кораблей")
                    .font(.headline)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: {
                        viewModel.goToMenu()
                    }) {
                        HStack {
                            Image(systemName: "house")
                            Text("В меню")
                        }
                        .font(.headline)
                        .padding()
                        .frame(width: 130)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue)
                        )
                        .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        resetAction()
                        viewModel.restartLevel()
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Заново")
                        }
                        .font(.headline)
                        .padding()
                        .frame(width: 130)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange)
                        )
                        .foregroundColor(.white)
                    }
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemGray6))
                    .shadow(radius: 10)
            )
            .padding(.horizontal, 32)
        }
    }
}

// Представление подтверждения возврата в меню
struct MenuConfirmView: View {
    let dismiss: () -> Void
    let goToMenu: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            
            VStack(spacing: 24) {
                Text("Выйти в меню?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Весь прогресс на уровне будет потерян")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Отмена")
                            .font(.headline)
                            .padding()
                            .frame(width: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        goToMenu()
                    }) {
                        Text("Выйти")
                            .font(.headline)
                            .padding()
                            .frame(width: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red)
                            )
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 10)
            )
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}
