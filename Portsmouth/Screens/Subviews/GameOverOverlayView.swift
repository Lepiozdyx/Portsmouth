import SwiftUI

struct GameOverOverlayView: View {
    let retryAction: () -> Void
    let returnToMenuAction: () -> Void
    
    var body: some View {
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
                Button(action: retryAction) {
                    Text("Попробовать снова")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                // Кнопка возврата в меню
                Button(action: returnToMenuAction) {
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
}

#Preview {
    GameOverOverlayView(
        retryAction: {},
        returnToMenuAction: {}
    )
}
