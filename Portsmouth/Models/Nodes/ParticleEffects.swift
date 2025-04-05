//
//  ParticleEffects.swift
//  Portsmouth
//
//  Created by Alex on 05.04.2025.
//

import SpriteKit
import UIKit

class ParticleEffects {
    
    // Эффект завершения уровня
    static func createLevelCompletionEffect() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        // Настройка базовых свойств эмиттера
        emitter.particleBirthRate = 100
        emitter.numParticlesToEmit = 200
        emitter.particleLifetime = 2.0
        emitter.particleLifetimeRange = 0.5
        
        // Настройка внешнего вида частиц
        emitter.particleColor = .yellow
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = nil // Для одного цвета
        
        // Настройка свойств движения
        emitter.particleSpeed = 200
        emitter.particleSpeedRange = 100
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2 // 360 градусов
        
        // Настройка размера частиц
        emitter.particleSize = CGSize(width: 10, height: 10)
        emitter.particleScaleRange = 0.5
        emitter.particleScaleSpeed = -0.5 // Уменьшаются с течением времени
        
        // Настройка прозрачности
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = -0.5 // Становятся прозрачнее с течением времени
        
        // Настройка вращения
        emitter.particleRotation = 0
        emitter.particleRotationRange = .pi * 2
        emitter.particleRotationSpeed = .pi // Скорость вращения
        
        // Режим наложения
        emitter.particleBlendMode = .add
        
        return emitter
    }
    
    // Эффект столкновения
    static func createCollisionEffect() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        // Настройка базовых свойств эмиттера
        emitter.particleBirthRate = 200
        emitter.numParticlesToEmit = 50
        emitter.particleLifetime = 0.8
        emitter.particleLifetimeRange = 0.2
        
        // Настройка внешнего вида частиц
        emitter.particleColor = .red
        emitter.particleColorBlendFactor = 1.0
        emitter.particleColorSequence = nil
        
        // Настройка свойств движения
        emitter.particleSpeed = 150
        emitter.particleSpeedRange = 50
        emitter.emissionAngle = 0
        emitter.emissionAngleRange = .pi * 2
        
        // Настройка размера частиц
        emitter.particleSize = CGSize(width: 8, height: 8)
        emitter.particleScaleRange = 0.3
        emitter.particleScaleSpeed = -0.4
        
        // Настройка прозрачности
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.2
        emitter.particleAlphaSpeed = -1.0
        
        // Настройка вращения
        emitter.particleRotation = 0
        emitter.particleRotationRange = .pi
        emitter.particleRotationSpeed = .pi * 2
        
        // Режим наложения
        emitter.particleBlendMode = .add
        
        return emitter
    }
    
    // Эффект движения корабля (след на воде)
    static func createShipTrailEffect() -> SKEmitterNode {
        let emitter = SKEmitterNode()
        
        // Настройка базовых свойств эмиттера
        emitter.particleBirthRate = 30
        emitter.particleLifetime = 1.5
        emitter.particleLifetimeRange = 0.5
        
        // Настройка внешнего вида частиц
        emitter.particleColor = .white
        emitter.particleColorBlendFactor = 0.7
        emitter.particleColorSequence = nil
        
        // Настройка свойств движения
        emitter.particleSpeed = 5
        emitter.particleSpeedRange = 5
        emitter.emissionAngle = .pi // Противоположно направлению движения
        emitter.emissionAngleRange = .pi / 4 // Небольшой разброс
        
        // Настройка размера частиц
        emitter.particleSize = CGSize(width: 5, height: 5)
        emitter.particleScaleRange = 0.2
        emitter.particleScaleSpeed = 0.2 // Увеличиваются с течением времени
        
        // Настройка прозрачности
        emitter.particleAlpha = 0.7
        emitter.particleAlphaRange = 0.3
        emitter.particleAlphaSpeed = -0.5
        
        // Режим наложения
        emitter.particleBlendMode = .add
        
        return emitter
    }
}
