//
//  WeatherDetailsView.swift
//  WeatherBackgroundUITest
//
//  Created by Nikita Kolomoec on 26.06.2023.
//

import SwiftUI

struct WeatherDetailsView: View {
    let tintColor: Color
    
    let residueType: Storm.Contents
    let residueStrenght: Double
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ResidueView(type: residueType, strenght: residueStrenght)
                    .frame(height: 62)
                    .offset(y: 30)
                    .zIndex(1)
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(tintColor.opacity(0.25))
                    .frame(height: 800)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 25))
                    .padding(.horizontal, 20)
            }
            .padding(.top, 200)
        }
    }
}

struct WeatherDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherDetailsView(tintColor: .blue, residueType: .rain, residueStrenght: 200)
    }
}
