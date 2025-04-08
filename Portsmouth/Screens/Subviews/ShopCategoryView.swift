import SwiftUI

struct ShopCategoryView: View {
    let title: String
    let items: [ShopItem]
    let selectedItemId: String
    let purchasedItemIds: Set<String>
    let currentCoins: Int
    let onSelect: (String) -> Void
    let onPurchase: (ShopItem) -> Bool
    
    @State private var currentIndex = 0
    
    var currentItem: ShopItem {
        return items[currentIndex]
    }
    
    var body: some View {
        Image(.undrly)
            .resizable()
            .frame(maxWidth: 350, maxHeight: 350)
            .overlay(alignment: .top) {
                Image(.undrly5)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160)
                    .overlay {
                        Text(title)
                            .font(.system(size: 18, weight: .heavy, design: .monospaced))
                            .foregroundStyle(.bloody)
                    }
                    .offset(y: -40)
            }
            .overlay {
                HStack {
                    // Кнопка предыдущего элемента
                    Button {
                        withAnimation {
                            currentIndex = (currentIndex - 1 + items.count) % items.count
                        }
                    } label: {
                        Image(.arrow)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .scaleEffect(x: -1)
                    }
                    .withSound()
                    
                    Spacer()
                    
                    // Текущий элемент
                    ShopItemView(
                        item: currentItem,
                        isSelected: currentItem.id == selectedItemId,
                        isPurchased: purchasedItemIds.contains(currentItem.id),
                        currentCoins: currentCoins,
                        onSelect: {
                            onSelect(currentItem.id)
                        },
                        onPurchase: {
                            return onPurchase(currentItem)
                        }
                    )
                    
                    Spacer()
                    
                    // Кнопка следующего элемента
                    Button {
                        withAnimation {
                            currentIndex = (currentIndex + 1) % items.count
                        }
                    } label: {
                        Image(.arrow)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                    .withSound()
                }
                .padding(.horizontal)
            }
    }
}

#Preview {
    let backgrounds: [ShopItem] = [
        ShopItem(id: "classicport", displayName: "classic", previewImageName: "classicport", actualAssetName: "bgclassic", price: 0),
        ShopItem(id: "sunsetport", displayName: "sunset", previewImageName: "sunsetport", actualAssetName: "bgsunset", price: 300),
        ShopItem(id: "nightport", displayName: "night", previewImageName: "nightport", actualAssetName: "bgnight", price: 300)
    ]
    
    return ShopCategoryView(
        title: "backgrounds",
        items: backgrounds,
        selectedItemId: "classicport",
        purchasedItemIds: ["classicport", "sunsetport"],
        currentCoins: 500,
        onSelect: { _ in },
        onPurchase: { _ in return true }
    )
}
