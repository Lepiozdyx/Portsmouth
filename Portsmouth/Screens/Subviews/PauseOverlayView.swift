import SwiftUI

struct PauseOverlayView: View {
    let resumeAction: () -> Void
    let returnToMenuAction: () -> Void
    
    var body: some View {
        ZStack {
            // Затемненный фон
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            // Диалог паузы
            VStack(spacing: 20) {
                Text("Пауза")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Кнопка продолжения
                Button(action: resumeAction) {
                    Text("Продолжить")
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
    PauseOverlayView(
        resumeAction: {},
        returnToMenuAction: {}
    )
}
