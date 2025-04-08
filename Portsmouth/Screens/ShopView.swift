import SwiftUI

struct ShopView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @StateObject private var shopService = ShopService.shared
    
    var body: some View {
        ZStack {
            BackgoundView(img: .bgmenu)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 60) {
                    // Категория фонов
                    ShopCategoryView(
                        title: "backgrounds",
                        items: shopService.availableBackgrounds,
                        selectedItemId: shopService.selectedBackgroundId,
                        purchasedItemIds: shopService.purchasedItemIds,
                        currentCoins: gameViewModel.coins,
                        onSelect: { backgroundId in
                            shopService.selectBackground(backgroundId)
                        },
                        onPurchase: { item in
                            let success = shopService.purchaseItem(item)
                            if success {
                                // Обновляем количество монет в ViewModel
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    gameViewModel.loadUserProgress()
                                }
                            }
                            return success
                        }
                    )
                    
                    // Категория кораблей
                    ShopCategoryView(
                        title: "ships",
                        items: shopService.availableShips,
                        selectedItemId: shopService.selectedShipId,
                        purchasedItemIds: shopService.purchasedItemIds,
                        currentCoins: gameViewModel.coins,
                        onSelect: { shipId in
                            shopService.selectShip(shipId)
                        },
                        onPurchase: { item in
                            let success = shopService.purchaseItem(item)
                            if success {
                                // Обновляем количество монет в ViewModel
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    gameViewModel.loadUserProgress()
                                }
                            }
                            return success
                        }
                    )
                }
                .padding(.top, 120)
            }
            
            // Счетчик монет
            VStack {
                HStack {
                    Spacer()
                    
                    CounterView(amount: gameViewModel.coins)
                }
                Spacer()
            }
            .padding([.top, .horizontal])
            
            // Кнопка возврата
            BackArrowButtonView()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ShopView(gameViewModel: GameViewModel())
}
