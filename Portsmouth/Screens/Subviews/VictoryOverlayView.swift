import SwiftUI

struct VictoryOverlayView: View {
    let nextLevelAction: () -> Void
    let returnToMenuAction: () -> Void
    
    var body: some View {
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
                Button(action: nextLevelAction) {
                    Text("Следующий уровень")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
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
    VictoryOverlayView(
        nextLevelAction: {},
        returnToMenuAction: {}
    )
}
