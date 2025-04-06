import SwiftUI

struct TopBarView: View {
    
    let coins: Int
    let pauseAction: () -> Void
    let restartAction: () -> Void
    
    var body: some View {
        HStack {
            // Кнопка меню (пауза)
            Button {
                pauseAction()
            } label: {
                Image(systemName: "pause.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Счетчик монет
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.yellow)
                Text("\(coins)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
            }
            .padding(8)
            .background(Color.black.opacity(0.5))
            .cornerRadius(10)
            
            Spacer()
            
            // Кнопка перезапуска
            Button {
                restartAction()
            } label: {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue.opacity(0.7))
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    TopBarView(coins: 150, pauseAction: {}, restartAction: {})
}
