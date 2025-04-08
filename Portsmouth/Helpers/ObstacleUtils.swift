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
}
