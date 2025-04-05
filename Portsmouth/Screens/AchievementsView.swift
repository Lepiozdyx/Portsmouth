//
//  AchievementsView.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Заголовок
            Text("Достижения")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            // Список достижений
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.achievements, id: \.id) { achievement in
                        AchievementCard(
                            achievement: achievement,
                            claimAction: {
                                viewModel.claimAchievementReward(achievement)
                            }
                        )
                    }
                }
                .padding()
            }
            
            Spacer()
            
            // Кнопка назад
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Назад")
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: 200)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

// Карточка достижения
struct AchievementCard: View {
    let achievement: Achievement
    let claimAction: () -> Void
    
    var body: some View {
        HStack {
            // Иконка достижения
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.blue : Color.gray)
                    .frame(width: 60, height: 60)
                
                if achievement.isUnlocked {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                        .font(.title)
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }
            }
            .padding(.trailing, 10)
            
            // Описание достижения
            VStack(alignment: .leading, spacing: 5) {
                Text(achievement.type.rawValue)
                    .font(.headline)
                    .foregroundColor(achievement.isUnlocked ? .primary : .secondary)
                
                Text(achievement.type.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            // Кнопка получения награды
            if achievement.isUnlocked && !achievement.isRewardClaimed {
                Button(action: claimAction) {
                    HStack {
                        Text("+10")
                        Image(systemName: "dollarsign.circle.fill")
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            } else if achievement.isRewardClaimed {
                Text("Получено")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

#Preview {
    AchievementsView(viewModel: GameViewModel())
}
