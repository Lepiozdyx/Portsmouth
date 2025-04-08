import Foundation

// Модель товара в магазине
struct ShopItem: Codable, Identifiable {
    let id: String
    let displayName: String
    let previewImageName: String  // Имя изображения для превью в магазине
    let actualAssetName: String   // Имя ресурса, который используется в игре
    let price: Int
    
    // Встроенные элементы не требуют покупки (цена = 0)
    var isBuiltIn: Bool {
        return price == 0
    }
}

// Сервис для управления покупками в магазине
class ShopService: ObservableObject {
    static let shared = ShopService()
    
    private let purchasedItemsKey = "com.riversportsmouth.purchasedItems"
    private let selectedBackgroundKey = "com.riversportsmouth.selectedBackground"
    private let selectedShipKey = "com.riversportsmouth.selectedShip"
    
    // Доступные фоны
    let availableBackgrounds: [ShopItem] = [
        ShopItem(id: "classicport", displayName: "Classic", previewImageName: "classicport", actualAssetName: "bgclassic", price: 0),
        ShopItem(id: "sunsetport", displayName: "Sunset", previewImageName: "sunsetport", actualAssetName: "bgsunset", price: 300),
        ShopItem(id: "nightport", displayName: "Night", previewImageName: "nightport", actualAssetName: "bgnight", price: 300)
    ]
    
    // Доступные корабли
    let availableShips: [ShopItem] = [
        ShopItem(id: "ship", displayName: "Sailboat", previewImageName: "ship", actualAssetName: "ship", price: 0),
        ShopItem(id: "ship2", displayName: "Cruiser", previewImageName: "ship2", actualAssetName: "ship2", price: 500),
        ShopItem(id: "ship3", displayName: "Yacht", previewImageName: "ship3", actualAssetName: "ship3", price: 500)
    ]
    
    @Published private(set) var purchasedItemIds: Set<String> {
        didSet {
            saveData()
        }
    }
    
    @Published private(set) var selectedBackgroundId: String {
        didSet {
            UserDefaults.standard.set(selectedBackgroundId, forKey: selectedBackgroundKey)
        }
    }
    
    @Published private(set) var selectedShipId: String {
        didSet {
            UserDefaults.standard.set(selectedShipId, forKey: selectedShipKey)
        }
    }
    
    private init() {
        // Загрузка списка купленных товаров
        if let purchasedData = UserDefaults.standard.array(forKey: purchasedItemsKey) as? [String] {
            self.purchasedItemIds = Set(purchasedData)
        } else {
            // Добавляем встроенные элементы как уже купленные
            var defaultPurchased = Set<String>()
            availableBackgrounds.filter { $0.isBuiltIn }.forEach { defaultPurchased.insert($0.id) }
            availableShips.filter { $0.isBuiltIn }.forEach { defaultPurchased.insert($0.id) }
            self.purchasedItemIds = defaultPurchased
        }
        
        // Загрузка выбранного фона и корабля
        self.selectedBackgroundId = UserDefaults.standard.string(forKey: selectedBackgroundKey) ?? availableBackgrounds[0].id
        self.selectedShipId = UserDefaults.standard.string(forKey: selectedShipKey) ?? availableShips[0].id
        
        // Сохраняем данные после инициализации всех свойств
        if UserDefaults.standard.array(forKey: purchasedItemsKey) == nil {
            saveData()
        }
    }
    
    // Получить выбранный фон
    var selectedBackground: ShopItem {
        return availableBackgrounds.first { $0.id == selectedBackgroundId } ?? availableBackgrounds[0]
    }
    
    // Получить выбранный корабль
    var selectedShip: ShopItem {
        return availableShips.first { $0.id == selectedShipId } ?? availableShips[0]
    }
    
    // Проверить, куплен ли товар
    func isItemPurchased(_ itemId: String) -> Bool {
        return purchasedItemIds.contains(itemId)
    }
    
    // Купить товар
    func purchaseItem(_ item: ShopItem) -> Bool {
        // Проверяем, есть ли у пользователя достаточно монет
        let progressService = UserProgressService.shared
        let currentCoins = progressService.getCoins()
        
        if currentCoins >= item.price {
            // Списываем монеты
            progressService.addCoins(-item.price)
            
            // Добавляем товар в список купленных
            purchasedItemIds.insert(item.id)
            
            // Устанавливаем товар как выбранный
            if availableBackgrounds.contains(where: { $0.id == item.id }) {
                selectedBackgroundId = item.id
            } else if availableShips.contains(where: { $0.id == item.id }) {
                selectedShipId = item.id
            }
            
            return true
        }
        
        return false
    }
    
    // Выбрать фон
    func selectBackground(_ backgroundId: String) {
        guard isItemPurchased(backgroundId) else { return }
        selectedBackgroundId = backgroundId
    }
    
    // Выбрать корабль
    func selectShip(_ shipId: String) {
        guard isItemPurchased(shipId) else { return }
        selectedShipId = shipId
    }
    
    // Сохранить данные
    private func saveData() {
        UserDefaults.standard.set(Array(purchasedItemIds), forKey: purchasedItemsKey)
    }
    
    // Сбросить данные (для отладки)
    func resetData() {
        // Оставляем только встроенные элементы
        var defaultPurchased = Set<String>()
        availableBackgrounds.filter { $0.isBuiltIn }.forEach { defaultPurchased.insert($0.id) }
        availableShips.filter { $0.isBuiltIn }.forEach { defaultPurchased.insert($0.id) }
        
        purchasedItemIds = defaultPurchased
        selectedBackgroundId = availableBackgrounds[0].id
        selectedShipId = availableShips[0].id
    }
}
