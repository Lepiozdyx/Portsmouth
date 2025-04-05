//
//  MainMenuView.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import SwiftUI

struct MainMenuView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack {
            // Логотип игры
            Text("Rivers Portsmouth")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.blue)
                .padding(.top, 50)
            
            Text("Games")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.blue.opacity(0.8))
            
            Spacer()
            
            // Информация об игроке
            HStack {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.title)
                
                Text("\(viewModel.player.coins)")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding()
            
            Spacer()
            
            // Кнопки меню
            VStack(spacing: 20) {
                MenuButton(title: "Играть", icon: "play.fill") {
                    viewModel.gameState = .levelSelection
                }
                
                MenuButton(title: "Магазин", icon: "cart.fill") {
                    viewModel.gameState = .shop
                }
                
                MenuButton(title: "Достижения", icon: "star.fill") {
                    viewModel.gameState = .achievements
                }
                
                MenuButton(title: "Настройки", icon: "gearshape.fill") {
                    // Будущая функциональность настроек
                }
            }
            
            Spacer()
            
            // Версия игры (для информации)
            Text("v1.0")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom)
        }
        .navigationBarHidden(true)
    }
}

// Кнопка главного меню
struct MenuButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(width: 250)
            .padding()
            .background(Color.blue)
            .cornerRadius(15)
            .shadow(radius: 3)
        }
    }
}

#Preview {
    MainMenuView(viewModel: GameViewModel())
}
