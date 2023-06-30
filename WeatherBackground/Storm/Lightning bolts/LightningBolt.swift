//
//  LightningBolt.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 28.06.2023.
//

import SwiftUI

class LightningBolt {
    var points = [CGPoint]()
    var width: Double
    var angle: Double
    
    init(starPoint: CGPoint, width: Double, angle: Double) {
        points.append(starPoint)
        self.width = width
        self.angle = angle
    }
}
