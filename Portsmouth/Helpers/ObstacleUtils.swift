import SpriteKit

struct ObstacleBlock {
    let minX: Int
    let minY: Int
    let maxX: Int
    let maxY: Int
    
    var width: Int {
        return maxX - minX + 1
    }
    
    var height: Int {
        return maxY - minY + 1
    }
    
    var position: CGPoint {
        let centerX = CGFloat(minX + maxX + 1) / 2.0
        let centerY = CGFloat(minY + maxY + 1) / 2.0
        return CGPoint(x: centerX, y: centerY)
    }
    
    var gridPositions: [GridPosition] {
        var positions = [GridPosition]()
        for x in minX...maxX {
            for y in minY...maxY {
                positions.append(GridPosition(x: x, y: y))
            }
        }
        return positions
    }
}

class ObstacleUtils {
    
    /// Находит прямоугольные блоки из переданного списка препятствий
    static func findRectangularBlocks(from obstacles: [ObstacleModel]) -> [ObstacleBlock] {
        // Создаем двумерный массив для отслеживания занятых позиций
        var grid = Array(repeating: Array(repeating: false, count: 20), count: 10)
        for obstacle in obstacles {
            if obstacle.gridPosition.x < 10 && obstacle.gridPosition.y < 20 {
                grid[obstacle.gridPosition.x][obstacle.gridPosition.y] = true
            }
        }
        
        // Множество для отслеживания посещенных позиций
        var visited = Set<GridPosition>()
        var blocks = [ObstacleBlock]()
        
        // Проходим по всем препятствиям и ищем максимальные прямоугольники
        for obstacle in obstacles {
            let pos = obstacle.gridPosition
            
            // Пропускаем уже посещенные позиции
            if visited.contains(pos) {
                continue
            }
            
            // Находим максимальный прямоугольник, начиная с текущей позиции
            var maxX = pos.x
            var maxY = pos.y
            
            // Расширяем по X, пока можно
            while maxX + 1 < 10 && grid[maxX + 1][pos.y] {
                maxX += 1
            }
            
            // Расширяем по Y, пока можно для всего диапазона X
            outer: while maxY + 1 < 20 {
                for x in pos.x...maxX {
                    if x >= 10 || maxY + 1 >= 20 || !grid[x][maxY + 1] {
                        break outer
                    }
                }
                maxY += 1
            }
            
            // Создаем блок и добавляем его в результат
            let block = ObstacleBlock(minX: pos.x, minY: pos.y, maxX: maxX, maxY: maxY)
            blocks.append(block)
            
            // Отмечаем все позиции блока как посещенные
            for position in block.gridPositions {
                visited.insert(position)
            }
        }
        
        return blocks
    }
    
    /// Выбирает подходящую текстуру для блока препятствий
    static func getTextureForBlock(_ block: ObstacleBlock) -> SKTexture {
        // Используем одну базовую текстуру для всех портов
        let texture = SKTexture(imageNamed: "port")
        return texture
    }
    
    /// Настраивает спрайт порта для поддержки 9-slice scaling
    static func configurePortNode(_ node: SKSpriteNode) {
        // В SKSpriteNode настраиваем centerRect для правильного масштабирования
        // Значения от 0 до 1 определяют, какая часть текстуры будет растягиваться
        node.centerRect = CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)
        
        // Режим масштабирования - растягивание
        node.xScale = 1.0
        node.yScale = 1.0
    }
    
    /// Добавляет декоративные элементы (контейнеры) на блок порта
    static func addDecorativeElements(to node: SKSpriteNode, blockWidth: Int, blockHeight: Int, cellSize: CGFloat) {
        // Определяем, нужно ли добавлять декорации на этот блок
        // (не на все блоки добавляем - некоторые могут быть причалами без контейнеров)
        let shouldAddDecorations = Bool.random()
        guard shouldAddDecorations && blockWidth >= 2 && blockHeight >= 2 else { return }
        
        // Размер блока порта в пикселях
        let portWidth = CGFloat(blockWidth) * cellSize
        let portHeight = CGFloat(blockHeight) * cellSize
        
        // Определяем тип размещения контейнеров в зависимости от формы блока
        if blockWidth > blockHeight * 2 {
            // Длинная горизонтальная пристань - ряд контейнеров
            addContainersInRow(to: node, width: portWidth, height: portHeight, cellSize: cellSize)
        } else if blockHeight > blockWidth * 2 {
            // Высокая вертикальная пристань - колонна контейнеров
            addContainersInColumn(to: node, width: portWidth, height: portHeight, cellSize: cellSize)
        } else {
            // Квадратный или почти квадратный порт - контейнеры группами
            addContainersInGroups(to: node, width: portWidth, height: portHeight, cellSize: cellSize)
        }
    }
    
    /// Размещает контейнеры в ряд (для горизонтальных пристаней)
    private static func addContainersInRow(to node: SKSpriteNode, width: CGFloat, height: CGFloat, cellSize: CGFloat) {
        // Доступные текстуры контейнеров
        let containerTextures = ["box", "box1", "box2", "box3"]
        
        // Размер контейнера (немного меньше, чем клетка)
        let containerWidth = cellSize * 0.8
        let containerHeight = cellSize * 0.8
        
        // Сколько контейнеров разместить
        let maxContainers = Int(width / containerWidth) - 1
        let containerCount = min(maxContainers, Int.random(in: 2...6))
        
        // Расстояние между контейнерами
        let spacing = (width - CGFloat(containerCount) * containerWidth) / CGFloat(containerCount + 1)
        
        // Размещаем контейнеры в ряд
        for i in 0..<containerCount {
            // Выбираем случайную текстуру
            let textureName = containerTextures.randomElement() ?? "box"
            let containerNode = SKSpriteNode(imageNamed: textureName)
            
            // Устанавливаем размер
            containerNode.size = CGSize(width: containerWidth, height: containerHeight)
            
            // Вычисляем позицию
            let xPos = -width/2 + spacing + containerWidth/2 + CGFloat(i) * (containerWidth + spacing)
            let yPos = CGFloat.random(in: -height/4...height/4) // Небольшое смещение по вертикали
            
            containerNode.position = CGPoint(x: xPos, y: yPos)
            
            // Небольшой случайный поворот для реалистичности
            containerNode.zRotation = CGFloat.random(in: -0.1...0.1)
            
            // Добавляем контейнер как дочерний узел
            node.addChild(containerNode)
        }
    }
    
    /// Размещает контейнеры в колонну (для вертикальных пристаней)
    private static func addContainersInColumn(to node: SKSpriteNode, width: CGFloat, height: CGFloat, cellSize: CGFloat) {
        // Доступные текстуры контейнеров
        let containerTextures = ["box", "box1", "box2", "box3"]
        
        // Размер контейнера
        let containerWidth = cellSize * 0.8
        let containerHeight = cellSize * 0.8
        
        // Сколько контейнеров разместить
        let maxContainers = Int(height / containerHeight) - 1
        let containerCount = min(maxContainers, Int.random(in: 2...6))
        
        // Расстояние между контейнерами
        let spacing = (height - CGFloat(containerCount) * containerHeight) / CGFloat(containerCount + 1)
        
        // Размещаем контейнеры в колонну
        for i in 0..<containerCount {
            // Выбираем случайную текстуру
            let textureName = containerTextures.randomElement() ?? "box"
            let containerNode = SKSpriteNode(imageNamed: textureName)
            
            // Устанавливаем размер
            containerNode.size = CGSize(width: containerWidth, height: containerHeight)
            
            // Вычисляем позицию
            let xPos = CGFloat.random(in: -width/4...width/4) // Небольшое смещение по горизонтали
            let yPos = -height/2 + spacing + containerHeight/2 + CGFloat(i) * (containerHeight + spacing)
            
            containerNode.position = CGPoint(x: xPos, y: yPos)
            
            // Небольшой случайный поворот для реалистичности
            containerNode.zRotation = CGFloat.random(in: -0.1...0.1)
            
            // Добавляем контейнер как дочерний узел
            node.addChild(containerNode)
        }
    }
    
    /// Размещает контейнеры группами (для квадратных портов)
    private static func addContainersInGroups(to node: SKSpriteNode, width: CGFloat, height: CGFloat, cellSize: CGFloat) {
        // Доступные текстуры контейнеров
        let containerTextures = ["box", "box1", "box2", "box3"]
        
        // Размер контейнера
        let containerWidth = cellSize * 0.8
        let containerHeight = cellSize * 0.8
        
        // Определяем, сколько групп контейнеров разместить
        let groupCount = Int.random(in: 1...3)
        
        // Для каждой группы
        for _ in 0..<groupCount {
            // Количество контейнеров в этой группе
            let containersInGroup = Int.random(in: 2...4)
            
            // Выбираем случайное место для группы
            let groupX = CGFloat.random(in: -width/2 + containerWidth...width/2 - containerWidth)
            let groupY = CGFloat.random(in: -height/2 + containerHeight...height/2 - containerHeight)
            
            // Создаем контейнеры в этой группе
            for i in 0..<containersInGroup {
                // Выбираем случайную текстуру
                let textureName = containerTextures.randomElement() ?? "box"
                let containerNode = SKSpriteNode(imageNamed: textureName)
                
                // Устанавливаем размер
                containerNode.size = CGSize(width: containerWidth, height: containerHeight)
                
                // Смещаем контейнер относительно центра группы
                // Немного хаотично, но близко друг к другу
                let offsetX = CGFloat.random(in: -containerWidth/2...containerWidth/2)
                let offsetY = CGFloat(i) * containerHeight * 0.7 // Стопка
                
                containerNode.position = CGPoint(x: groupX + offsetX, y: groupY + offsetY)
                
                // Небольшой случайный поворот
                containerNode.zRotation = CGFloat.random(in: -0.1...0.1)
                
                // Добавляем контейнер
                node.addChild(containerNode)
            }
        }
    }
}
