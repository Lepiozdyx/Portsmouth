import SwiftUI

struct SoundButtonModifier: ViewModifier {
    @StateObject private var settings = SettingsManager.shared
    
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                settings.playSound()
            }
    }
}

extension View {
    func withClickSound() -> some View {
        self.modifier(SoundButtonModifier())
    }
}

struct SoundButtonStyle: ButtonStyle {
    @StateObject private var settings = SettingsManager.shared
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                if newValue {
                    settings.playSound()
                }
            }
    }
}

extension Button {
    func withSound() -> some View {
        self.buttonStyle(SoundButtonStyle())
    }
}
