//
//  DayCardView.swift
//  Weather
//
//  Created by Mark Davis on 10/22/24.
//

import SwiftUI

struct DayCardView: View {
    let dayName: String
    let maxTemp: String
    let minTemp: String
    let weatherIconName: String

    var body: some View {
        VStack(alignment: .center) {
            Text(dayName)
                .padding()
            
            Text(maxTemp+"°")
                .font(.headline)
            Text(minTemp+"°")
                .font(.subheadline)
                .padding(.bottom, 8)
                        
            Image(systemName: weatherIconName)
                .font(.system(size: 32))
            
            Spacer()
        }
        .frame(width: 75, height: 160, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 1)
        )
    }
}

#Preview {
    DayCardView(dayName: "Mon",
                maxTemp: "25",
                minTemp: "12",
                weatherIconName: "cloud.rain")
}
