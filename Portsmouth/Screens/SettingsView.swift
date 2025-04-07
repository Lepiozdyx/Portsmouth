import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settings = SettingsManager.shared
    
    var body: some View {
        ZStack {
            BackgoundView(img: .bgmenu)
            
            BackArrowButtonView()
            
            ZStack {
                SettingsFrame()
                
                VStack(spacing: 30) {
                    HStack(alignment: .bottom, spacing: 30) {
                        Image(.sound)
                            .resizable()
                            .frame(width: 75, height: 70)
                        
                        ToggleButtonView(name: "sound", isOn: settings.isSoundOn) {
                            settings.toggleSound()
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 30) {
                        Image(.music)
                            .resizable()
                            .frame(width: 75, height: 70)
                        
                        ToggleButtonView(name: "music", isOn: settings.isMusicOn) {
                            settings.toggleMusic()
                        }
                        .disabled(!settings.isSoundOn) // Блокируем кнопку музыки если звук выключен
                        .opacity(settings.isSoundOn ? 1.0 : 0.5) // Визуальное отображение блокировки
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    SettingsView()
}

// MARK: - SettingsFrame
struct SettingsFrame: View {
    
    @StateObject private var settings = SettingsManager.shared
    
    var body: some View {
        Image(.undrly)
            .resizable()
            .frame(maxWidth: 350, maxHeight: 400)
            .overlay(alignment: .top) {
                Image(.undrly2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .offset(y: -40)
            }
            .overlay(alignment: .bottom) {
                Button {
                    settings.requestReview()
                } label: {
                    Image(.rateButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150)
                        .offset(y: 40)
                }
                .withSound()
            }
            .padding()
    }
}

// MARK: - ToggleButtonView
struct ToggleButtonView: View {
    let name: String
    let isOn: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Text(name)
                .font(.system(size: 18, weight: .heavy, design: .monospaced))
                .foregroundStyle(.bloody)
            
            Button {
                withAnimation {
                    action()
                }
            } label: {
                Image(.undrly3)
                    .resizable()
                    .frame(width: 100, height: 50)
                    .overlay(alignment: isOn ? .trailing : .leading) {
                        Image(.circleButton)
                            .resizable()
                            .frame(width: 45, height: 40)
                            .overlay {
                                Text(isOn ? "on" : "off")
                                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal, 6)
                    }
            }
            .withSound()
        }
    }
}
