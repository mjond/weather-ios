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
                .padding(.bottom, 20)
            
            Image(systemName: day.weatherIconName)
                .accessibilityLabel("\(day.weatherIconName)")
                .accessibilityAddTraits(.isImage)
                .font(.system(size: 80))
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
            
            HStack {
                HStack {
                    Text("Sunrise:")
                        .accessibilityLabel("Sunrise")
                        .accessibilityAddTraits(.isStaticText)
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    let sunriseTimeComponent = Calendar.current.dateComponents([.hour, .minute], from: day.sunrise)
                    
                    Text(day.sunrise, format: .dateTime.hour().minute())
                        .accessibilityLabel(DateComponentsFormatter.localizedString(from: sunriseTimeComponent, unitsStyle: .spellOut) ?? "\(day.sunrise)")
                        .accessibilityAddTraits(.isStaticText)
                        .fontDesign(.serif)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.trailing, 15)

                HStack {
                    Text("Sunset:")
                        .accessibilityLabel("Sunset")
                        .accessibilityAddTraits(.isStaticText)
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    let sunsetTimeComponent = Calendar.current.dateComponents([.hour, .minute], from: day.sunrise)

                    Text(day.sunset, format: .dateTime.hour().minute())
                        .accessibilityLabel(DateComponentsFormatter.localizedString(from: sunsetTimeComponent, unitsStyle: .spellOut) ?? "\(day.sunset)")
                        .accessibilityAddTraits(.isStaticText)
                        .fontDesign(.serif)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TitleColor"))
                }
            }
            .padding(.bottom)

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
                    
                    Text("\(day.precipitationProbability)%")
                        .accessibilityLabel("\(day.precipitationProbability)")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Precipitation amount:")
                        .accessibilityLabel("Precipitation amount:")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.precipitationAmount)")
                        .accessibilityLabel("\(day.precipitationAmount)")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.bottom, 10)
                
                Divider()
                    .foregroundStyle(Color("TitleColor"))
                
                HStack {
                    Text("UV index:")
                        .accessibilityLabel("UV index:")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.uvIndexMax)")
                        .accessibilityLabel("\(day.uvIndexMax)")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.vertical, 10)

                Divider()
                    .foregroundStyle(Color("TitleColor"))
                
                HStack {
                    Text("Wind speed:")
                        .accessibilityLabel("Wind speed:")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.windSpeed)")
                        .accessibilityLabel("\(day.windSpeed)")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Wind gusts:")
                        .accessibilityLabel("Wind gusts:")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.windGust)")
                        .accessibilityLabel("\(day.windGust)")
                        .accessibilityAddTraits(.isStaticText)
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.bottom, 10)
                
                Divider()
                    .foregroundStyle(Color("TitleColor"))
                
            }
            .padding(.horizontal, 35)
            
            Spacer()
        } //: VStack
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .padding()
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
                                         windGust: "27 km/h"))
}
