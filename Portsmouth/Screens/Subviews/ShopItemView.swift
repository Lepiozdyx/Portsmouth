import SwiftUI

struct ShopItemView: View {
    let item: ShopItem
    let isSelected: Bool
    let isPurchased: Bool
    let currentCoins: Int
    let onSelect: () -> Void
    let onPurchase: () -> Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Название элемента
            Image(.undrly6)
                .resizable()
                .frame(width: 180, height: 50)
                .overlay {
                    Text(item.displayName)
                        .font(.system(size: 18, weight: .heavy, design: .monospaced))
                        .foregroundStyle(.bloody)
                }
            
            // Изображение товара и контейнер для действия
            Button {
                if isPurchased {
                    onSelect()
                } else if !item.isBuiltIn {
                    let _ = onPurchase()
                }
            } label: {
                VStack(spacing: 0) {
                    Image(item.previewImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 160)
                        .padding(.vertical, 10)
                        .overlay {
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.green)
                                    .background(Circle().fill(Color.white))
                                    .offset(x: 50, y: -60)
                            }
                        }
                    
                    // Цена или статус
                    Image(.undrly3)
                        .resizable()
                        .frame(width: 120, height: 55)
                        .overlay {
                            if isPurchased {
                                // Если элемент куплен
                                if isSelected {
                                    Text("active")
                                        .font(.system(size: 16, weight: .heavy, design: .monospaced))
                                        .foregroundStyle(.green)
                                } else {
                                    Button {
                                        onSelect()
                                    } label: {
                                        Text("use")
                                            .font(.system(size: 16, weight: .heavy, design: .monospaced))
                                            .foregroundStyle(.blue)
                                    }
                                    .buttonStyle(.plain)
                                }
                            } else {
                                // Если элемент не куплен, показываем цену
                                HStack {
                                    Text("\(item.price)")
                                        .font(.system(size: 18, weight: .heavy, design: .monospaced))
                                        .foregroundStyle(.bloody)
                                    
                                    Image(.coin)
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                }
                            }
                        }
                }
            }
            .buttonStyle(.plain)
            .disabled(!isPurchased && item.price > currentCoins)
            .opacity(!isPurchased && item.price > currentCoins ? 0.8 : 1.0)
        }
    }
}

#Preview {
    ShopItemView(
        item: ShopItem(id: "item1", displayName: "classic", previewImageName: "classicport", actualAssetName: "bgclassic", price: 0),
        isSelected: true,
        isPurchased: true,
        currentCoins: 500,
        onSelect: {},
        onPurchase: { return true }
    )
    .frame(width: 200)
}
