import SwiftUI

struct MainMenuView: View {
    // MARK: - ViewModel
    
    @ObservedObject var gameViewModel: GameViewModel
    
    // MARK: - Представление
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .cyan.opacity(0.8)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Контент меню
            VStack(spacing: 30) {
                // Счетчик монет
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.title)
                        .foregroundColor(.yellow)
                    
                    Text("\(gameViewModel.coins)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.black.opacity(0.2))
                .cornerRadius(15)
                
                Spacer()
                
                // Кнопки меню
                VStack(spacing: 20) {
                    // Кнопка "Играть"
                    MenuButton(title: "Играть", icon: "play.fill") {
                        gameViewModel.showLevelSelection()
                    }
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

/// Компонент для кнопки главного меню
struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(width: 250, height: 60)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}

#Preview {
    MainMenuView(gameViewModel: GameViewModel())
}
