import SwiftUI

struct AchievementsView: View {

    @State private var achievementService = AchievementService.shared

    private let achievements = Achievement.allCases
    
    // Состояние для модального окна с детальной информацией
    @State private var selectedAchievement: Achievement?
    @State private var showAchievementDetail = false
    
    var body: some View {
        ZStack {
            BackgoundView(img: .bglvls)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 40) {
                    ForEach(achievements) { achievement in
                        let isUnlocked = achievementService.isAchievementUnlocked(achievement)
                        
                        // Создаем разную компоновку для четных и нечетных достижений
                        if achievement.id % 2 == 0 {
                            HStack {
                                Spacer()
                                
                                AchievementItemView(
                                    achievement: achievement,
                                    isUnlocked: isUnlocked
                                )
                                .onTapGesture {
                                    selectedAchievement = achievement
                                    showAchievementDetail = true
                                }
                            }
                        } else {
                            HStack {
                                AchievementItemView(
                                    achievement: achievement,
                                    isUnlocked: isUnlocked
                                )
                                .onTapGesture {
                                    selectedAchievement = achievement
                                    showAchievementDetail = true
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 80) // Отступ для кнопки назад
                .padding(.bottom, 20)
            }
            
            // Кнопка возврата
            BackArrowButtonView()
            
            // Модальное окно с информацией о достижении
            if showAchievementDetail, let achievement = selectedAchievement {
                AchievementDetailView(
                    achievement: achievement,
                    isUnlocked: achievementService.isAchievementUnlocked(achievement),
                    isShowing: $showAchievementDetail
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // При появлении экрана можно выполнить дополнительные проверки достижений
            achievementService.checkAchievements()
        }
    }
}

// Модальное окно с подробной информацией о достижении
struct AchievementDetailView: View {
    let achievement: Achievement
    let isUnlocked: Bool
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            // Полупрозрачный затемненный фон
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowing = false
                }
            
            // Карточка достижения
            VStack(spacing: 15) {
                // Заголовок
                Text(achievement.title)
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(isUnlocked ? .yellow : .gray)
                
                // Изображение
                Image(achievement.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)
                    .opacity(isUnlocked ? 1.0 : 0.5)
                
                // Описание
                Text(achievement.description)
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundColor(.bloody)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Статус
                HStack {
                    Circle()
                        .fill(isUnlocked ? Color.green : Color.gray)
                        .frame(width: 12, height: 12)
                    
                    Text(isUnlocked ? "achieved" : "locked")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(isUnlocked ? .green : .gray)
                }
                
                // Кнопка закрытия
                Button {
                    isShowing = false
                } label: {
                    Image(.backButton)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                }
                .withClickSound()
                .padding(.top, 10)
            }
            .padding(.vertical, 30)
            .padding(.horizontal, 20)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .shadow(radius: 15)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    AchievementsView()
}
