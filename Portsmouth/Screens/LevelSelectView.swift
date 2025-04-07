import SwiftUI

struct LevelSelectView: View {
    // MARK: - ViewModel
    
    @ObservedObject var gameViewModel: GameViewModel
    
    // MARK: - Constants
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Фоновый градиент
            LinearGradient(
                gradient: Gradient(colors: [.blue.opacity(0.7), .cyan.opacity(0.4)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Основной контент
            VStack {
                // Заголовок
                Text("Выбор уровня")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                
                // Счетчик монет
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(gameViewModel.coins)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.2))
                .cornerRadius(20)
                
                // Сетка уровней
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(gameViewModel.getAllLevels()) { level in
                            LevelButton(
                                level: level,
                                isUnlocked: gameViewModel.isLevelUnlocked(id: level.id)
                            ) {
                                gameViewModel.startGame(levelId: level.id)
                            }
                        }
                    }
                    .padding()
                }
                
                // Кнопка возврата
                Button(action: {
                    gameViewModel.returnToMainMenu()
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Назад")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 3)
                }
                .withSound()
                .buttonStyle(.plain)
                .padding(.bottom)
            }
        }
        .navigationBarHidden(true)
    }
}

/// Кнопка выбора уровня
struct LevelButton: View {
    let level: LevelModel
    let isUnlocked: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            if isUnlocked {
                action()
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(isUnlocked ? Color.blue.opacity(0.7) : Color.gray.opacity(0.5))
                    .frame(width: 100, height: 100)
                    .shadow(radius: 3)
                
                VStack {
                    if isUnlocked {
                        Text("\(level.id)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(level.name)
                            .font(.caption)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
    }
}

#Preview {
    LevelSelectView(gameViewModel: GameViewModel())
}
