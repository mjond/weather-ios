//
//  DayRowView.swift
//  Weather
//
//  Created by Mark Davis on 11/22/24.
//

import SwiftUI

struct DayRowView: View {
    let dayName: String
    let maxTemp: String
    let minTemp: String
    let weatherIconName: String

    var body: some View {
        HStack {
            Text(dayName)
                .accessibilityLabel(dayName)
                .accessibilityAddTraits(.isStaticText)
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Spacer()
            
            Image(systemName: weatherIconName)
                .accessibilityLabel(weatherIconName)
                .accessibilityAddTraits(.isImage)
                .font(.system(size: 26))
                .foregroundStyle(Color("TitleColor"))
                .padding(.trailing, 50)
            
            Text(minTemp+"°")
                .accessibilityLabel("\(minTemp) degrees")
                .accessibilityAddTraits(.isStaticText)
                .fontWeight(.light)
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Text(" ----- ")
            
            Text(maxTemp+"°")
                .accessibilityLabel("\(maxTemp) degrees")
                .accessibilityAddTraits(.isStaticText)
                .fontWeight(.bold)
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
        } //: HStack
        .background(.clear)
    }
}

#Preview {
    DayRowView(dayName: "Mon",
               maxTemp: "25",
               minTemp: "12",
               weatherIconName: "cloud.rain")
}
