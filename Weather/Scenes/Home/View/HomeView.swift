//
//  ContentView.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var nav = NavigationStateManager()
    @State private var showDetails: Bool = false
    @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                switch viewModel.state {
                case .loading:
                    HomeLoadingView()
                        .shimmer()

                case .failure:
                    HomeFailureView {
                        Task {
                            await viewModel.getWeather()
                        }
                    }

                case let .success(weatherModel):
                    VStack {
                        VStack {
                            Text(weatherModel.locationName)
                                .font(.title)
                                .padding(.bottom, 2)

                            Text(weatherModel.currentTemperature+"°")
                                .font(.system(size: 46))
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            
                            Text("Feels like \(weatherModel.apparentTemperature)°")
                                .padding(.bottom, 5)

                            Image(systemName: weatherModel.currentWeatherIconName)
                                .font(.system(size: 80))
                                .padding(.bottom)
                            
                            VStack {
                                HStack {
                                    Text("Sunrise:")
                                        .fontWeight(.semibold)
                                    let sunriseDate = weatherModel.dailyForecast[0].sunrise
                                    Text(sunriseDate, format: .dateTime.hour().minute())
                                }

                                HStack {
                                    Text("Sunset:")
                                        .fontWeight(.semibold)
                                    let sunsetDate = weatherModel.dailyForecast[0].sunset
                                    Text(sunsetDate, format: .dateTime.hour().minute())
                                }
                            }

                        } //: VStack
                        .padding(.bottom, 20)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(weatherModel.hourlyForecast) { hour in
                                    HourlyCardView(date: hour.date,
                                                   temp: hour.temperature,
                                                   weatherIconName: hour.weatherIconName)
                                }
                            }
                        } //: ScrollView
                        .padding()

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(weatherModel.dailyForecast) { day in
                                    DayCardView(dayName: day.abbreviatedDayName,
                                                maxTemp: day.maximumTemperature,
                                                minTemp: day.minimumTemperature,
                                                weatherIconName: day.weatherIconName)
                                    .onTapGesture {
                                        nav.path.append(day)
                                    }
                                }
                            }
                        } //: ScrollView
                        .padding()
                        
                        Spacer()
                    } //: VStack
                    .padding(.top, 70)
                }
            } //: VStack
            .task {
                await viewModel.getWeather()
            }
            .navigationDestination(for: DailyWeatherModel.self) { day in
                DayDetailView(dayName: day.fullDayName,
                              maxTemp: day.maximumTemperature,
                              minTemp: day.minimumTemperature,
                              precipitationProbability: day.precipitationProbability,
                              precipitationAmount: day.precipitationAmount,
                              uvIndex: day.uvIndexMax,
                              sunrise: day.sunrise,
                              sunset: day.sunset)
            }
        } //: NavigationStack
        .environmentObject(nav)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationStateManager())
    }
}
