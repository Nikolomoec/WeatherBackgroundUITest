//
//  Cloud.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 22.06.2023.
//

import SwiftUI

class Cloud {
    enum Thickness: CaseIterable {
        case none, thin, light, regular, thick, UK
    }
    
    var position: CGPoint
    var imageNumber: Int
    let speed = Double.random(in: 4...12)
    var scale: Double
    
    init(imageNumber: Int, scale: Double) {
        self.imageNumber = imageNumber
        self.scale = scale
        
        let startX = Double.random(in: -400...400)
        let startY = Double.random(in: -50...200)
        position = CGPoint(x: startX, y: startY)
    }
}
