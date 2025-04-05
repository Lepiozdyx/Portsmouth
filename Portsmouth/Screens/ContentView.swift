//
//  ContentView.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Основное представление в зависимости от состояния игры
                switch viewModel.gameState {
                case .menu:
                    MainMenuView(viewModel: viewModel)
                case .levelSelection:
                    LevelSelectionView(viewModel: viewModel)
                case .playing:
                    GameView(viewModel: viewModel)
                case .gameOver:
                    // Обрабатывается внутри GameView
                    GameView(viewModel: viewModel)
                case .victory:
                    // Обрабатывается внутри GameView
                    GameView(viewModel: viewModel)
                case .shop:
                    ShopView(viewModel: viewModel)
                case .achievements:
                    AchievementsView(viewModel: viewModel)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    ContentView()
}
