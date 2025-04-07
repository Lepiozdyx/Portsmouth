import SwiftUI

struct VictoryOverlayView: View {
    let nextLevelAction: () -> Void
    let returnToMenuAction: () -> Void
    
    var body: some View {
        ZStack {
            // Затемненный фон
            BackgoundView(img: .bgmenu)
            
            VStack {
                HStack {
                    Button {
                        returnToMenuAction()
                    } label: {
                        Image(.backButton)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding([.top, .horizontal])
            
            GameOverFrame(img: .win)
            
            VStack {
                HStack {
                    Image(.coin)
                        .resizable()
                        .frame(width: 60, height: 60)
                    
                    Text("+100")
                        .font(.system(size: 24, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.bloody)
                }
                
                Button {
                    nextLevelAction()
                } label: {
                    Image(.nextButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 130)
                }
            }
            .padding(.top)
        }
    }
}

#Preview {
    VictoryOverlayView(
        nextLevelAction: {},
        returnToMenuAction: {}
    )
}
