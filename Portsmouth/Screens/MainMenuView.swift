import SwiftUI

struct MainMenuView: View {
    // MARK: - ViewModel
    
    @ObservedObject var gameViewModel: GameViewModel
    
    // MARK: - Представление
    
    var body: some View {
        ZStack {
            BackgoundView(img: .bgmenu)
            
            // Контент меню
            VStack(spacing: 30) {
                // Счетчик монет
                HStack(alignment: .top) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(.settingsButton)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    .withClickSound()

                    Spacer()
                    CounterView(amount: gameViewModel.coins)
                }
                .padding([.horizontal, .top])
                
                Spacer()
                
                Image(.logo)
                    .resizable()
                    .frame(width: 250, height: 110)
                
                Spacer()
                Spacer()
                
                // Кнопки меню
                VStack(spacing: 40) {
                    // Кнопка "Играть"
                    Button {
                        gameViewModel.showLevelSelection()
                    } label: {
                        Image(.playButton)
                            .resizable()
                            .frame(width: 175, height: 75)
                    }
                    .withSound()
                    
                    HStack(alignment: .top) {
                        NavigationLink {
                            ShopView(gameViewModel: gameViewModel)
                        } label: {
                            Image(.shopButton)
                                .resizable()
                                .frame(width: 80, height: 100)
                        }
                        .withClickSound()
                        
                        Spacer()
                        
                        NavigationLink {
                            AchievementsView()
                        } label: {
                            Image(.achievementsButton)
                                .resizable()
                                .frame(width: 80, height: 100)
                        }
                        .withClickSound()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    MainMenuView(gameViewModel: GameViewModel())
}
