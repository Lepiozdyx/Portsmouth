import SwiftUI

struct AchievementItemView: View {
    let achievement: Achievement
    let isUnlocked: Bool
    
    var body: some View {
        Image(achievement.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 150)
            .opacity(isUnlocked ? 1.0 : 0.5)
            .overlay(alignment: .bottom) {
                Image(.undrly1)
                    .resizable()
                    .frame(width: 120, height: 35)
                    .overlay {
                        // Статус достижения
                        if isUnlocked {
                            Text("achieved")
                                .font(.system(size: 16, weight: .heavy, design: .monospaced))
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                        }
                    }
                    .offset(y: 30)
            }
    }
}

#Preview {
    VStack(spacing: 80) {
        AchievementItemView(achievement: .firstnavigation, isUnlocked: true)
        AchievementItemView(achievement: .kingoftheport, isUnlocked: false)
    }
    .padding()
}
