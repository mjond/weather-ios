//
//  HourlyCardView.swift
//  Weather
//
//  Created by Mark Davis on 10/26/24.
//

import SwiftUI

struct HourlyCardView: View {
    let date: Date
    let temp: String
    let weatherIconName: String

    var body: some View {
        VStack(alignment: .center) {
            let hourComponent = Calendar.current.dateComponents([.hour], from: date)
            Text(date, format: .dateTime.hour())
                .accessibilityLabel(DateComponentsFormatter.localizedString(from: hourComponent, unitsStyle: .spellOut) ?? "\(date)")
                .accessibilityAddTraits(.isStaticText)
                .font(.subheadline)
                .fontDesign(.serif)
                .foregroundStyle(Color("SubheadingColor"))
                .padding(.top, 10)
                .padding(.bottom, 1)
            
            Text(temp+"°")
                .accessibilityLabel("\(temp) degrees")
                .accessibilityAddTraits(.isStaticText)
                .fontWeight(.bold)
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Spacer()
            
            Image(systemName: weatherIconName)
                .accessibilityLabel("\(weatherIconName)")
                .accessibilityAddTraits(.isImage)
                .font(.system(size: 22))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Spacer()
        }
        .frame(width: 55, height: 100, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("SubheadingColor"), lineWidth: 1)
        )
        .background(.clear)
    }
}

#Preview {
    HourlyCardView(date: Date.now,
                   temp: "14",
                   weatherIconName: "cloud.rain")
}
