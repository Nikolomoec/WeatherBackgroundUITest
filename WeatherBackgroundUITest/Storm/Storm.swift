//
//  Strorm.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 25.06.2023.
//

import SwiftUI

class Storm {
    enum Contents: CaseIterable {
        case none, rain, snow, thunderstorm
    }
    
    var drops = [StormDrop]()
    var lastUpdate = Date.now
    var image: Image
    
    init(type: Contents, directions: Angle, strenght: Int) {
        switch type {
        case .snow:
            image = Image("snow")
        default:
            image = Image("rain")
        }
        
        for _ in 0..<strenght {
            drops.append(StormDrop(type: type, direction: directions + .degrees(90)))
        }
    }
    
    func update(date: Date, size: CGSize) {
        let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
        let devisor = size.height / size.width
        
        for drop in drops {
            let radians = drop.direction.radians
            
            drop.x += cos(radians) * drop.speed * delta * devisor
            drop.y += sin(radians) * drop.speed * delta * devisor
            
            if drop.x < -0.2 {
                drop.x += 1.4
            }
            
            if drop.y > 1.2 {
                drop.x = Double.random(in: -0.2...1.2)
                drop.y -= 1.4
            }
        }
        
        lastUpdate = date
    }
}
