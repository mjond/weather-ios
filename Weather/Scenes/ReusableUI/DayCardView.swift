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
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Text(maxTemp+"°")
                .font(.headline)
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            Text(minTemp+"°")
                .font(.subheadline)
                .fontDesign(.serif)
                .foregroundStyle(Color("SubheadingColor"))
                .padding(.bottom, 8)
            
            Spacer()
            
            Image(systemName: weatherIconName)
                .font(.system(size: 32))
                .foregroundStyle(Color("TitleColor"))
            
            Spacer()
        }
        .frame(width: 75, height: 160, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("TitleColor"), lineWidth: 1)
        )
        .background(.clear)
    }
}

#Preview {
    DayCardView(dayName: "Mon",
                maxTemp: "25",
                minTemp: "12",
                weatherIconName: "cloud.rain")
}
