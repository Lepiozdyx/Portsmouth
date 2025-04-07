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
                    Button {
                        // показать экран настроек
                    } label: {
                        Image(.settingsButton)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }

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
                    
                    HStack(alignment: .top) {
                        Button {
                            // показать экран магазина
                        } label: {
                            Image(.shopButton)
                                .resizable()
                                .frame(width: 80, height: 100)
                        }
                        
                        Spacer()
                        
                        Button {
                            // показать экран достижений
                        } label: {
                            Image(.achievementsButton)
                                .resizable()
                                .frame(width: 80, height: 100)
                        }
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
