//
//  LevelSelectionView.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import SwiftUI

struct LevelSelectionView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // Количество колонок в сетке
    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        VStack {
            // Заголовок
            Text("Выбор уровня")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            // Сетка уровней
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.levels) { level in
                        LevelCell(level: level, isUnlocked: level.isUnlocked)
                            .onTapGesture {
                                if level.isUnlocked {
                                    viewModel.selectLevel(level)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
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

// Ячейка для выбора уровня
struct LevelCell: View {
    let level: Level
    let isUnlocked: Bool
    
    var body: some View {
        ZStack {
            // Фон
            RoundedRectangle(cornerRadius: 15)
                .fill(isUnlocked ? Color.blue : Color.gray)
                .opacity(isUnlocked ? 0.8 : 0.4)
                .shadow(radius: isUnlocked ? 5 : 2)
            
            VStack {
                // Иконка замка для заблокированных уровней
                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
                
                Text(level.name)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(8)
            }
        }
        .frame(height: 100)
        .padding(5)
    }
}

#Preview {
    LevelSelectionView(viewModel: GameViewModel())
}
