//
//  DayDetailView.swift
//  Weather
//
//  Created by Mark Davis on 10/23/24.
//

import SwiftUI

struct DayDetailView: View {
    @EnvironmentObject var nav: NavigationStateManager

    let dayName: String
    let weatherIconName: String
    let maxTemp: String
    let minTemp: String
    let precipitationProbability: String
    let precipitationAmount: String
    let uvIndex: String
    let sunrise: Date
    let sunset: Date
    let windSpeed: String

    var body: some View {
        VStack {
            Text(dayName)
                .font(.system(size: 36))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 20)
            
            Image(systemName: weatherIconName)
                .font(.system(size: 80))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom)

            VStack {
                Text("Max: \(maxTemp)°")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))

                Text("Min: \(minTemp)°")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
            }
            .padding(.bottom)
            
            HStack {
                HStack {
                    Text("Sunrise:")
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    let sunriseDate = sunrise
                    Text(sunriseDate, format: .dateTime.hour().minute())
                        .fontDesign(.serif)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.trailing, 15)

                HStack {
                    Text("Sunset:")
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    let sunsetDate = sunrise
                    Text(sunsetDate, format: .dateTime.hour().minute())
                        .fontDesign(.serif)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TitleColor"))
                }
            }
            .padding(.bottom)

            Text("Chance of precipitation: \(precipitationProbability)%")
                .font(.system(size: 18))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Text("Precipitation amount: \(precipitationAmount)")
                .font(.system(size: 18))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 10)

            Text("UV Index: \(uvIndex)")
                .font(.system(size: 18))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 10)
            
            Text("Wind speed: \(windSpeed)")
                .font(.system(size: 18))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
            
            Spacer()
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding(.bottom, 35)
        .background(Color("BackgroundColor"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if nav.path.count > 0 {
                        nav.path.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(Color("TitleColor"))
                }
            }
        }
    }
}

#Preview {
    DayDetailView(dayName: "Monday",
                  weatherIconName: "cloud",
                  maxTemp: "22",
                  minTemp: "12",
                  precipitationProbability: "15",
                  precipitationAmount: "1 in",
                  uvIndex: "3",
                  sunrise: Date(),
                  sunset: Date(),
                  windSpeed: "14")
}
