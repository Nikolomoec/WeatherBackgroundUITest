//
//  ContentView.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 22.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var cloudThickness = Cloud.Thickness.regular
    @State private var time = 0.0
    
    @State private var stormType = Storm.Contents.none
    @State private var rainIntensity = 500.0
    @State private var rainAngle = 0.0
    
    @State private var maximumBolts = 4.0
    @State private var forkProbability = 20.0
    
    @State private var showingSetting = true
    
    let backgroundTopStops: [Gradient.Stop] = [
        .init(color: .midnightStart, location: 0),
        .init(color: .midnightStart, location: 0.25),
        .init(color: .sunriseStart, location: 0.33),
        .init(color: .sunnyDayStart, location: 0.38),
        .init(color: .sunnyDayStart, location: 0.7),
        .init(color: .sunriseStart, location: 0.78),
        .init(color: .midnightStart, location: 0.82),
        .init(color: .midnightStart, location: 1)
    ]
    
    let backgroundBottomStops: [Gradient.Stop] = [
        .init(color: .midnightEnd, location: 0),
        .init(color: .midnightEnd, location: 0.25),
        .init(color: .sunriseEnd, location: 0.33),
        .init(color: .sunnyDayEnd, location: 0.38),
        .init(color: .sunnyDayEnd, location: 0.7),
        .init(color: .sunsetEnd, location: 0.78),
        .init(color: .midnightEnd, location: 0.82),
        .init(color: .midnightEnd, location: 1)
    ]
    
    let cloudTopStops: [Gradient.Stop] = [
        .init(color: .darkCloudStart, location: 0),
        .init(color: .darkCloudStart, location: 0.25),
        .init(color: .sunriseCloudStart, location: 0.33),
        .init(color: .lightCloudStart, location: 0.38),
        .init(color: .lightCloudStart, location: 0.7),
        .init(color: .sunsetCloudStart, location: 0.78),
        .init(color: .darkCloudStart, location: 0.82),
        .init(color: .darkCloudStart, location: 1)
    ]
    
    let cloudBottomStops: [Gradient.Stop] = [
        .init(color: .darkCloudEnd, location: 0),
        .init(color: .darkCloudEnd, location: 0.25),
        .init(color: .sunriseCloudEnd, location: 0.33),
        .init(color: .lightCloudEnd, location: 0.38),
        .init(color: .lightCloudEnd, location: 0.7),
        .init(color: .sunsetCloudEnd, location: 0.78),
        .init(color: .darkCloudEnd, location: 0.82),
        .init(color: .darkCloudEnd, location: 1)
    ]
    
    let starStops: [Gradient.Stop] = [
        .init(color: .white, location: 0),
        .init(color: .white, location: 0.25),
        .init(color: .clear, location: 0.33),
        .init(color: .clear, location: 0.38),
        .init(color: .clear, location: 0.7),
        .init(color: .clear, location: 0.78),
        .init(color: .white, location: 0.82),
        .init(color: .white, location: 1)
    ]
    
    let rainBackgroundStops: [Gradient.Stop] = [
        .init(color: .rainStart, location: 0),
        .init(color: .rainEnd, location: 1)
    ]
    
    var starOpacity: Double {
        let color = starStops.interpolated(amount: time)
        return color.getComponents().alpha
    }
    
    var body: some View {
        ZStack {
            StarsView()
                .opacity(starOpacity)
            
            SunView(progress: time)
                .opacity(sunOpacity)
                .animation(.easeInOut(duration: 2), value: sunOpacity)
            
            CloudsView(
                thickness: cloudThickness,
                topTint: cloudTopStops.interpolated(amount: time),
                bottomTint: cloudBottomStops.interpolated(amount: time)
            )
            
            LightningView(maximumBolts: Int(maximumBolts), forkProbability: Int(forkProbability))
            
            if stormType != .none {
                StrormView(type: stormType, direction: .degrees(rainAngle), strenght: Int(rainIntensity))
            }
            
            WeatherDetailsView(tintColor: backgroundTopStops.interpolated(amount: time), residueType: stormType, residueStrenght: rainIntensity)
        }
        .preferredColorScheme(.dark)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                LinearGradient(colors: [
                    backgroundTopStops.interpolated(amount: time),
                    backgroundBottomStops.interpolated(amount: time)
                ], startPoint: .top, endPoint: .bottom)
                
                LinearGradient(stops: rainBackgroundStops, startPoint: .top, endPoint: .bottom)
                    .opacity(rainBackgroundOpacity)
            }
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 1), value: rainBackgroundOpacity)
        )
        .safeAreaInset(edge: .bottom) {
            VStack {
                
                Button("Toogle Controls") {
                    withAnimation {
                        showingSetting.toggle()
                    }
                }
                
                if showingSetting {
                    VStack {
                        Text(formattedTime)
                            .padding(.top)
                        
                        Picker("Thickness", selection: $cloudThickness) {
                            ForEach(Cloud.Thickness.allCases, id: \.self) { thickness in
                                Text(String(describing: thickness).capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        HStack {
                            Text("Time:")
                            Slider(value: $time)
                        }
                        .padding()
                        
                        Picker("Precipitation", selection: $stormType) {
                            ForEach(Storm.Contents.allCases, id: \.self) { stormType in
                                Text(String(describing: stormType).capitalized)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        HStack {
                            Text("Intensity")
                            Slider(value: $rainIntensity, in: 0...1000)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("Angle")
                            Slider(value: $rainAngle, in: 0...90)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("Max Bolts:")
                            Slider(value: $maximumBolts, in: 0...10)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            Text("Fork %")
                            Slider(value: $forkProbability, in: 0...100)
                        }
                        .padding(.horizontal)
                    }
                    .transition(.move(edge: .bottom))
                }
            }
            .padding(5)
            .frame(maxWidth: .infinity)
            .background(.regularMaterial)
        }
    }
    
    var formattedTime: String {
        let start = Calendar.current.startOfDay(for: Date.now)
        let advanced = start.addingTimeInterval(time * 24 * 60 * 60)
        return advanced.formatted(date: .omitted, time: .shortened)
    }
    
    var sunOpacity: Double {
        if stormType == .none {
            return 1
        } else {
            return 0
        }
    }
    
    var rainBackgroundOpacity: Double {
        if stormType != .none && (0.38...0.7).contains(time) {
            return 1
        } else {
            return 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
