//
//  Array-GradientStop.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 24.06.2023.
//

import SwiftUI

extension Array where Element == Gradient.Stop {
    func interpolated(amount: Double) -> Color {
        guard let initialStop = self.first else {
            fatalError("Attemp to read a color from empty stop array")
        }
        
        var firstStop = initialStop
        var secondStop = initialStop
        
        for stop in self {
            if stop.location < amount {
                firstStop = stop
            } else {
                secondStop = stop
                break
            }
        }
        
        let totalDiff = secondStop.location - firstStop.location
        
        if totalDiff > 0 {
            let relativeDiff = (amount - firstStop.location) / totalDiff
            return firstStop.color.interpolated(to: secondStop.color, amount: relativeDiff)
        } else {
            return firstStop.color.interpolated(to: secondStop.color, amount: 0)
        }
    }
}
