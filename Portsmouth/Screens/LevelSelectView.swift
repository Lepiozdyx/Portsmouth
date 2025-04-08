import SwiftUI

struct LevelSelectView: View {
    // MARK: - ViewModel
    @ObservedObject var gameViewModel: GameViewModel
    
    // Массив кораблей
    private let boats: [ImageResource] = [.boat1, .boat2, .boat3, .boat4, .boat5]
    private var randomizedBoats: [ImageResource] {
        Array(boats.shuffled().prefix(9))
    }
    
    // MARK: - Body
    var body: some View {
        let levels = gameViewModel.getAllLevels()
        let boatsForLevels = randomizedBoats
        
        ZStack {
            BackgoundView(img: .bglvls)
            
            VStack {
                HStack {
                    Button {
                        gameViewModel.returnToMainMenu()
                    } label: {
                        Image(.backButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                    }
                    .withSound()
                    
                    Spacer()
                }
                Spacer()
            }
            .padding([.top, .horizontal])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 30) {
                    ForEach(Array(zip(levels.indices, levels)), id: \.1.id) { index, level in
                        let boatImage = boatsForLevels[index % boatsForLevels.count]
                        LevelButton(
                            level: level,
                            isUnlocked: gameViewModel.isLevelUnlocked(id: level.id),
                            boatImage: boatImage,
                            flipped: index.isMultiple(of: 2)
                        ) {
                            gameViewModel.startGame(levelId: level.id)
                        }
                    }
                }
                .padding(.top, 60)
            }
        }
        .navigationBarHidden(true)
    }
}

/// Кнопка выбора уровня
struct LevelButton: View {
    let level: LevelModel
    let isUnlocked: Bool
    let boatImage: ImageResource
    let flipped: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            if isUnlocked {
                action()
            }
        } label: {
            ZStack {
                Image(boatImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160)
                    .opacity(isUnlocked ? 1 : 0.7)
                    .scaleEffect(x: flipped ? -1 : 1)
                    .shadow(color: .black, radius: 3, x: 1, y: 1)
        
                VStack {
                    if isUnlocked {
                        Text("\(level.id)")
                            .font(.system(size: 40, weight: .heavy, design: .monospaced))
                            .shadow(color: .black, radius: 3, x: 1, y: 1)
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 32))
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
