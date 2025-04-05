//
//  ShopView.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import SwiftUI

struct ShopView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Заголовок и баланс
            HStack {
                Text("Магазин")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                    Text("\(viewModel.player.coins)")
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.1))
                .cornerRadius(20)
            }
            .padding()
            
            // Секции товаров
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Секция с фонами
                    VStack(alignment: .leading) {
                        Text("Фоны уровней")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.shopItems.filter {
                                    if case .background = $0.itemType { return true } else { return false }
                                }, id: \.id) { item in
                                    if case .background(let backgroundType) = item.itemType {
                                        ShopItemCard(
                                            title: backgroundType.displayName,
                                            price: item.price,
                                            isUnlocked: item.isUnlocked,
                                            isSelected: viewModel.player.currentBackgroundEnum == backgroundType,
                                            icon: "photo.fill",
                                            buyAction: {
                                                viewModel.buyItem(item)
                                            },
                                            selectAction: {
                                                viewModel.selectBackgroundType(backgroundType)
                                            }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    Divider()
                    
                    // Секция со скинами кораблей
                    VStack(alignment: .leading) {
                        Text("Скины корабликов")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.shopItems.filter {
                                    if case .shipSkin = $0.itemType { return true } else { return false }
                                }, id: \.id) { item in
                                    if case .shipSkin(let shipType) = item.itemType {
                                        ShopItemCard(
                                            title: shipType.displayName,
                                            price: item.price,
                                            isUnlocked: item.isUnlocked,
                                            isSelected: viewModel.player.currentShipTypeEnum == shipType,
                                            icon: "boat.fill",
                                            buyAction: {
                                                viewModel.buyItem(item)
                                            },
                                            selectAction: {
                                                viewModel.selectShipType(shipType)
                                            }
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.bottom)
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

// Карточка товара в магазине
struct ShopItemCard: View {
    let title: String
    let price: Int
    let isUnlocked: Bool
    let isSelected: Bool
    let icon: String
    let buyAction: () -> Void
    let selectAction: () -> Void
    
    var body: some View {
        VStack {
            // Иконка товара
            Image(systemName: icon)
                .font(.system(size: 40))
                .foregroundColor(isUnlocked ? (isSelected ? .blue : .black) : .gray)
                .padding(.top)
            
            // Название товара
            Text(title)
                .font(.callout)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .frame(height: 40)
                .padding(.horizontal, 5)
            
            // Кнопка покупки или выбора
            Button(action: {
                if isUnlocked {
                    selectAction()
                } else {
                    buyAction()
                }
            }) {
                if isUnlocked {
                    Text(isSelected ? "Выбрано" : "Выбрать")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(isSelected ? Color.green : Color.blue)
                        .cornerRadius(8)
                } else {
                    HStack {
                        Text("\(price)")
                            .fontWeight(.bold)
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.orange)
                    .cornerRadius(8)
                }
            }
            .disabled(isUnlocked && isSelected)
            .padding(.bottom)
        }
        .frame(width: 120, height: 180)
        .background(Color(UIColor.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.blue : Color.gray, lineWidth: isSelected ? 3 : 1)
        )
        .cornerRadius(10)
        .shadow(radius: isUnlocked ? 3 : 1)
    }
}

#Preview {
    ShopView(viewModel: GameViewModel())
}
