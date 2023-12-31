//
//  StarsView.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 25.06.2023.
//

import SwiftUI

struct StarsView: View {
    @State var starField = StarField()
    @State var meteorShower = MeteorShower()
    
    let stormType: Storm.Contents
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let timeInterval = timeline.date.timeIntervalSince1970
                starField.update(date: timeline.date)
                
                // Meteor Shower
                if stormType == .none {
                    meteorShower.update(date: timeline.date, size: size)
                    
                    let rightColors = [.clear, Color(red: 0.8, green: 1, blue: 1), .white]
                    let leftColors = Array(rightColors.reversed())
                    
                    for meteor in meteorShower.meteors {
                        var contextCopy = context
                        
                        if meteor.isMovingRight {
                            contextCopy.rotate(by: .degrees(10))
                            let path = Path(CGRect(x: meteor.x - meteor.lenght, y: meteor.y, width: meteor.lenght, height: 2))
                            contextCopy.fill(path, with: .linearGradient(.init(colors: rightColors), startPoint: CGPoint(x: meteor.x - meteor.lenght, y: 0), endPoint: CGPoint(x: meteor.x, y: 0)))
                        } else {
                            contextCopy.rotate(by: .degrees(-10))
                            let path = Path(CGRect(x: meteor.x, y: meteor.y, width: meteor.lenght, height: 2))
                            contextCopy.fill(path, with: .linearGradient(.init(colors: leftColors), startPoint: CGPoint(x: meteor.x, y: 0), endPoint: CGPoint(x: meteor.x + meteor.lenght, y: 0)))
                        }
                        
                        let glow = Path(ellipseIn: CGRect(x: meteor.x - 1, y: meteor.y - 1, width: 4, height: 4))
                        contextCopy.addFilter(.blur(radius: 1))
                        contextCopy.fill(glow, with: .color(white: 1))
                    }
                }
                
                context.addFilter(.blur(radius: 0.3))
                
                for (index, star) in starField.stars.enumerated() {
                    let path = Path(ellipseIn: CGRect(x: star.x, y: star.y, width: star.size, height: star.size))
                    
                    // Flickering & Bloom
                    if star.flickerInterval == 0 {
                        // flashing star
                        var flashLevel = sin(Double(index) + timeInterval * 4)
                        flashLevel = abs(flashLevel)
                        flashLevel /= 2
                        context.opacity = 0.5 + flashLevel
                    } else {
                        // Blooming star
                        var flashLevel = sin(Double(index) + timeInterval)
                        flashLevel *= star.flickerInterval
                        flashLevel -= star.flickerInterval - 1
                        
                        if flashLevel > 0 {
                            var contextCopy = context
                            contextCopy.opacity = flashLevel
                            contextCopy.addFilter(.blur(radius: 3))
                            
                            contextCopy.fill(path, with: .color(white: 1))
                            contextCopy.fill(path, with: .color(white: 1))
                            contextCopy.fill(path, with: .color(white: 1))
                        }
                        
                        context.opacity = 1
                    }
                    
                    // Red, Orange Stars
                    if index.isMultiple(of: 5) {
                        context.fill(path, with: .color(red: 1, green: 0.85, blue: 0.8))
                    } else {
                        context.fill(path, with: .color(white: 1))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .mask(
            LinearGradient(colors: [.white, .clear], startPoint: .top, endPoint: .bottom)
        )
    }
}

struct StarsView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView(stormType: .none)
    }
}
