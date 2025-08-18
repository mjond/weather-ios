//
//  DayDetailView.swift
//  Weather
//
//  Created by Mark Davis on 10/23/24.
//

import SwiftUI

struct DayDetailView: View {
    @EnvironmentObject var nav: NavigationStateManager

    let day: DailyWeatherModel

    var body: some View {
        VStack {
            Text(day.fullDayName)
                .accessibilityLabel("\(day.fullDayName)")
                .accessibilityAddTraits(.isStaticText)
                .font(.system(size: 36))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 10)

            Image(systemName: day.weatherIconName)
                .accessibilityLabel("\(day.weatherIconName)")
                .accessibilityAddTraits(.isImage)
                .font(.system(size: 70))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom)

            VStack {
                Text("Max: \(day.maximumTemperature)°")
                    .accessibilityLabel("Maximum temperature is \(day.maximumTemperature) degrees")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))

                Text("Min: \(day.minimumTemperature)°")
                    .accessibilityLabel("Minimum temperature is \(day.minimumTemperature) degrees")
                    .accessibilityAddTraits(.isStaticText)
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))
            }
            .padding(.bottom)

            VStack {
                HStack {
                    PropertyCardView(title: "Sunrise", iconName: "sunrise", isTimeBased: true, date: day.sunrise)

                    Spacer()

                    PropertyCardView(title: "Sunset", iconName: "sunset", isTimeBased: true, date: day.sunset)
                }
                .padding(.vertical, 5)

                HStack {
                    PropertyCardView(title: "Precipitation", iconName: "drop.fill", value: day.precipitationAmount)

                    Spacer()

                    PropertyCardView(title: "UV Index", iconName: "sun.max", value: day.uvIndexMax)
                }
                .padding(.vertical, 5)

                WindCardView(windSpeed: day.windSpeed,
                             windGust: day.windGust,
                             windDirectionDegrees: day.windDirectionDegrees)
                    .padding(.vertical, 5)
            }
            .padding(.horizontal, 5)

            VStack {
                Divider()
                    .foregroundStyle(Color("TitleColor"))

                HStack {
                    Text("Chance of precipitation:")
                        .accessibilityLabel("Chance of precipitation:")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))

                    Spacer()

                    Text("\(day.precipitationProbability)")
                        .accessibilityLabel("\(day.precipitationProbability)")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.top, 10)

                Divider()
                    .foregroundStyle(Color("TitleColor"))
            }
            .padding(.horizontal, 12)

            Spacer()
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding()
        .background(Color("BackgroundColor"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    if !nav.path.isEmpty {
                        nav.path.removeLast()
                    }
                } label: {
                    Image(systemName: "chevron.left.circle")
                        .font(.system(size: 22))
                        .foregroundStyle(Color("TitleColor"))
                        .accessibilityLabel("Back button")
                        .accessibilityAddTraits(.isButton)
                        .accessibilityHint("This button will take you back to the home view")
                }
            }
        }
    }
}

#Preview {
    DayDetailView(day: DailyWeatherModel(date: Date(),
                                         minimumTemperature: "22",
                                         maximumTemperature: "27",
                                         weatherCode: 1,
                                         precipitationProbability: "15%",
                                         precipitationAmount: "0 mm",
                                         uvIndexMax: "6",
                                         sunset: Date(),
                                         sunrise: Date(),
                                         windSpeed: "14 km/h",
                                         windGust: "27 km/h",
                                         windDirectionDegrees: "125"))
}
