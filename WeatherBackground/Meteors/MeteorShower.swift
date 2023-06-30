//
//  MeteorShower.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 30.06.2023.
//

import SwiftUI

class MeteorShower {
    var meteors = Set<Meteor>()
    var lastUpdate = Date.now
    
    var lastCreationDate = Date.now
    var nextCreationDelay = Double.random(in: 5...10)
    
    func update(date: Date, size: CGSize) {
        let delta = date.timeIntervalSince1970 - lastUpdate.timeIntervalSince1970
        
        if lastCreationDate + nextCreationDelay < .now {
            createMeteor(size: size)
        }
        
        for meteor in meteors {
            if meteor.isMovingRight {
                meteor.x += delta * meteor.speed
            } else {
                meteor.x -= delta * meteor.speed
            }
            
            meteor.speed -= delta * 900
            
            if meteor.speed < 0 {
                meteors.remove(meteor)
            } else if meteor.lenght < 100 {
                meteor.lenght += delta * 300
            }
        }
        
        lastUpdate = date
    }
    
    func createMeteor(size: CGSize) {
        let meteor: Meteor
        
        if Bool.random() {
            meteor = Meteor(x: 0, y: Double.random(in: 100...200), isMovingRight: true)
        } else {
            meteor = Meteor(x: size.width, y: Double.random(in: 100...200), isMovingRight: false)
        }
        
        meteors.insert(meteor)
        lastCreationDate = .now
        nextCreationDelay = Double.random(in: 5...10)
    }
}
