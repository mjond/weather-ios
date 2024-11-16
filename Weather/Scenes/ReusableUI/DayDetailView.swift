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
    
//    let dayName: String
//    let weatherIconName: String
//    let maxTemp: String
//    let minTemp: String
//    let precipitationProbability: String
//    let precipitationAmount: String
//    let uvIndex: String
//    let sunrise: Date
//    let sunset: Date
//    let windSpeed: String
//    let windGust: String

    var body: some View {
        VStack {
            Text(day.fullDayName)
                .font(.system(size: 36))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom, 20)
            
            Image(systemName: day.weatherIconName)
                .font(.system(size: 80))
                .fontDesign(.serif)
                .foregroundStyle(Color("TitleColor"))
                .padding(.bottom)

            VStack {
                Text("Max: \(day.maximumTemperature)°")
                    .font(.system(size: 22))
                    .fontWeight(.bold)
                    .fontDesign(.serif)
                    .foregroundStyle(Color("TitleColor"))

                Text("Min: \(day.minimumTemperature)°")
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
                    Text(day.sunrise, format: .dateTime.hour().minute())
                        .fontDesign(.serif)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.trailing, 15)

                HStack {
                    Text("Sunset:")
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    Text(day.sunset, format: .dateTime.hour().minute())
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
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.precipitationProbability)%")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Precipitation amount:")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.precipitationAmount)")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.bottom, 10)
                
                Divider()
                    .foregroundStyle(Color("TitleColor"))
                
                HStack {
                    Text("UV index:")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.uvIndexMax)")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.vertical, 10)

                Divider()
                    .foregroundStyle(Color("TitleColor"))
                
                HStack {
                    Text("Wind speed:")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.windSpeed)")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                }
                .padding(.top, 10)
                
                HStack {
                    Text("Wind gusts:")
                        .font(.system(size: 18))
                        .fontDesign(.serif)
                        .foregroundStyle(Color("TitleColor"))
                    
                    Spacer()
                    
                    Text("\(day.windGust)")
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
