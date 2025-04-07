import SwiftUI

struct GameOverOverlayView: View {
    let retryAction: () -> Void
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
                    .withSound()
                    .buttonStyle(.plain)
                    
                    Spacer()
                }
                Spacer()
            }
            .padding([.top, .horizontal])
            
            GameOverFrame(img: .lose)
            
            Button {
                retryAction()
            } label: {
                Image(.tryagainButton)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
            }
            .withSound()
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    GameOverOverlayView(
        retryAction: {},
        returnToMenuAction: {}
    )
}

// MARK: - GameOverFrame
struct GameOverFrame: View {
    
    let img: ImageResource
    
    var body: some View {
        Image(.undrly)
            .resizable()
            .frame(maxWidth: 300, maxHeight: 250)
            .overlay(alignment: .top) {
                Image(img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(y: -40)
                    .background(alignment: .top) {
                        Image(.boat)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110)
                            .offset(y: -95)
                    }
            }
            .padding()
    }
}
