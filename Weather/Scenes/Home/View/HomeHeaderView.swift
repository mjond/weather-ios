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
        if !showCollapsedView {
            VStack {
                Text(weatherModel.locationName)
                    .accessibilityLabel("\(weatherModel.locationName)")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.system(size: 30))
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .padding(.bottom, 2)

                Text(weatherModel.currentTemperature + "°")
                    .accessibilityLabel("\(weatherModel.currentTemperature) degrees")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.system(size: 46))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))

                Text("Feels like \(weatherModel.apparentTemperature)°")
                    .accessibilityLabel("Feels like \(weatherModel.apparentTemperature) degrees")
                    .accessibilityAddTraits(.isStaticText)
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
                    .accessibilityLabel("\(weatherModel.locationName)")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.system(size: 30))
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
                    .padding(.bottom, 2)

                HStack {
                    Text(weatherModel.currentTemperature + "°" + " | " + "Feels like \(weatherModel.apparentTemperature)°")
                        .accessibilityLabel("\(weatherModel.currentTemperature) degrees, feels like \(weatherModel.apparentTemperature) degrees")
                        .accessibilityAddTraits(.isStaticText)
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
            } //: VStack
        }
    }
}
