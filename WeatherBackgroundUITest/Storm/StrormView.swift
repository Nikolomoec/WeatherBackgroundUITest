//
//  StrormView.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 25.06.2023.
//

import SwiftUI

struct StrormView: View {
    let storm: Storm
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                storm.update(date: timeline.date, size: size)
                
                for drop in storm.drops {
                    var contextCopy = context
                    
                    let xPos = drop.x * size.width
                    let yPos = drop.y * size.height
                    
                    contextCopy.opacity = drop.opacity
                    contextCopy.translateBy(x: xPos, y: yPos)
                    contextCopy.rotate(by: drop.direction + drop.rotation)
                    contextCopy.scaleBy(x: drop.xScale, y: drop.yScale)
                    contextCopy.draw(storm.image, at: .zero)
                }
            }
        }
        .ignoresSafeArea()
    }
    
    init(type: Storm.Contents, direction: Angle, strenght: Int) {
        storm = Storm(type: type, directions: direction, strenght: strenght)
    }
}

struct StrormView_Previews: PreviewProvider {
    static var previews: some View {
        StrormView(type: .rain, direction: .zero, strenght: 200)
    }
}
