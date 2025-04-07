import SwiftUI

struct TopBarView: View {
    
    let coins: Int
    let returnToMenuAction: () -> Void
    let restartAction: () -> Void
    
    var body: some View {
        HStack {
            // Кнопка меню (пауза)
            Button {
                returnToMenuAction()
            } label: {
                Image(.backButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
            }
            
            Spacer()
            
            // Счетчик монет
            CounterView(amount: coins)
            
            Spacer()
            
            // Кнопка перезапуска
            Button {
                restartAction()
            } label: {
                Image(.restartButton)
                    .resizable()
                    .frame(width: 60, height: 60)
            }
        }
    }
}

#Preview {
    TopBarView(coins: 150, returnToMenuAction: {}, restartAction: {})
}
