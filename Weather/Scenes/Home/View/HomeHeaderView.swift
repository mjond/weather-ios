//
//  HomeHeaderView.swift
//  Weather
//
//  Created by Mark Davis on 12/14/24.
//

import SwiftUI

struct HomeHeaderView: View {
    var weatherModel: HomeModel
    var offset: CGFloat
    @Binding var showCollapsedView: Bool

    var body: some View {
        Group {
            if !showCollapsedView {
                VStack {
                    Text(weatherModel.locationName)
                        .font(.system(size: 30))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                        .padding(.bottom, 2)

                    Text(weatherModel.currentTemperature + "°")
                        .font(.system(size: 46))
                        .fontWeight(.bold)
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))

                    Text("Feels like \(weatherModel.apparentTemperature)°")
                        .fontDesign(.serif)
                        .foregroundStyle(Color("SubheadingColor"))
                        .padding(.bottom, 5)

//                Image(systemName: weatherModel.currentWeatherIconName)
//                    .accessibilityLabel("\(weatherModel.currentWeatherIconName)")
//                    .accessibilityAddTraits(.isImage)
//                    .font(.system(size: 65))
//                    .fontDesign(.serif)
//                    .foregroundStyle(Color("TitleColor"))
//                    .padding(.bottom)
                } //: VStack
            } else {
                VStack {
                    Text(weatherModel.locationName)
                        .font(.system(size: 30))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                        .padding(.bottom, 2)

                    HStack {
                        Text(weatherModel.currentTemperature + "°" + " | " + "Feels like \(weatherModel.apparentTemperature)°")
                            .fontDesign(.serif)
                            .foregroundStyle(Color("TitleColor"))
                    }
                } //: VStack
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isHeader)
        .accessibilityLabel(accessibilitySummary)
    }

    private var accessibilitySummary: String {
        "\(weatherModel.locationName), \(weatherModel.currentTemperature) degrees, feels like \(weatherModel.apparentTemperature) degrees"
    }
}
