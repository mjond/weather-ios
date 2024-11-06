//
//  ContentView.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var nav = NavigationStateManager()
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    @ObservedObject var locationManager: LocationManager = LocationManager()
    @State private var goToSettings: Bool = false

    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                switch locationManager.locationStatus {
                case .authorizedWhenInUse, .authorizedAlways:
                    VStack {
                        switch viewModel.state {
                        case .loading:
                            HomeLoadingView()
                                .shimmer()

                        case .failure:
                            HomeFailureView {
                                Task {
                                    await viewModel.getWeather(lat: locationManager.lastLocation?.coordinate.latitude,
                                                               long: locationManager.lastLocation?.coordinate.longitude)
                                }
                            }

                        case let .success(weatherModel):
                            VStack {
                                VStack {
                                    Text(weatherModel.locationName)
                                        .font(.title)
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("TitleColor"))
                                        .padding(.bottom, 2)

                                    Text(weatherModel.currentTemperature+"°")
                                        .font(.system(size: 46))
                                        .fontWeight(.bold)
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("TitleColor"))
                                    
                                    Text("Feels like \(weatherModel.apparentTemperature)°")
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("SubheadingColor"))
                                        .padding(.bottom, 5)

                                    Image(systemName: weatherModel.currentWeatherIconName)
                                        .font(.system(size: 80))
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("TitleColor"))
                                        .padding(.bottom)
                                    
                                    VStack {
                                        HStack {
                                            Text("Sunrise:")
                                                .fontDesign(.serif)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color("TitleColor"))
                                            let sunriseDate = weatherModel.dailyForecast[0].sunrise
                                            Text(sunriseDate, format: .dateTime.hour().minute())
                                                .fontDesign(.serif)
                                                .foregroundStyle(Color("TitleColor"))
                                        }

                                        HStack {
                                            Text("Sunset:")
                                                .fontDesign(.serif)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color("TitleColor"))
                                            let sunsetDate = weatherModel.dailyForecast[0].sunset
                                            Text(sunsetDate, format: .dateTime.hour().minute())
                                                .fontDesign(.serif)
                                                .foregroundStyle(Color("TitleColor"))
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

                                Link(destination: URL(string: "https://open-meteo.com/")!, label: {
                                    Text("Data Source: Open Meteo")
                                        .font(.footnote)
                                        .fontDesign(.serif)
                                        .underline()
                                })

                            } //: VStack
                            .padding(.top, 15)
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        goToSettings.toggle()
                                    } label: {
                                        Image(systemName: "gearshape.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(Color("TitleColor"))
                                    }
                                }
                            }
                        }
                    } //: VStack
                    .background(Color("BackgroundColor"))
                    .task {
                        if locationManager.lastLocation != nil {
                            await viewModel.getWeather(lat: locationManager.lastLocation?.coordinate.latitude,
                                                       long: locationManager.lastLocation?.coordinate.longitude)
                        }
                    }
                    .onChange(of: locationManager.lastLocation) {
                        Task {
                            if locationManager.locationStatus == .authorizedWhenInUse ||
                                locationManager.locationStatus == .authorizedWhenInUse {
                                await viewModel.getWeather(lat: locationManager.lastLocation?.coordinate.latitude,
                                                           long: locationManager.lastLocation?.coordinate.longitude)
                            }
                        }
                    }
//                    .onChange(of: locationManager.locationStatus) {
//                        if locationManager.locationStatus == .authorizedWhenInUse ||
//                            locationManager.locationStatus == .authorizedWhenInUse {
//                            Task {
//                                await viewModel.getWeather(lat: locationManager.lastLocation?.coordinate.latitude,
//                                                           long: locationManager.lastLocation?.coordinate.longitude)
//                            }
//                        }
//                    }
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
                    .navigationDestination(isPresented: $goToSettings) {
                        SettingsView(settings: $viewModel.settings)
                    }
                case .notDetermined:
                    LocationPendingView()
                case .denied, .restricted:
                    LocationDeniedView()
                default:
                    LocationDeniedView()
                }
            } //: VStack
            
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
