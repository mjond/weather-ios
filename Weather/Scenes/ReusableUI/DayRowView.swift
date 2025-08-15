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
                .padding(.trailing, 35)

            HStack {
                Text(minTemp + "°")
                    .accessibilityLabel("\(minTemp) degrees")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.system(size: 20))
                    .fontWeight(.light)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .frame(minWidth: 35)

                Text(" ----- ")
                    .frame(minWidth: 40)

                Text(maxTemp + "°")
                    .accessibilityLabel("\(maxTemp) degrees")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .frame(minWidth: 35)
            } //: HStack
            .frame(minWidth: 110)
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
