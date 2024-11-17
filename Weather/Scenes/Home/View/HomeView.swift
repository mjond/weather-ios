//
//  ContentView.swift
//  Weather
//
//  Created by Mark Davis on 11/7/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var nav = NavigationStateManager()
    @ObservedObject var locationManager: LocationManager = LocationManager()
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
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
                                    await viewModel.getWeather(location: locationManager.lastLocation)
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
                                    
                                    HStack {
                                        HStack {
                                            Text("Sunrise:")
                                                .fontDesign(.serif)
                                                .foregroundStyle(Color("TitleColor"))
                                            let sunriseDate = weatherModel.currentSunrise
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
                                            let sunsetDate = weatherModel.currentSunset
                                            Text(sunsetDate, format: .dateTime.hour().minute())
                                                .fontDesign(.serif)
                                                .fontWeight(.semibold)
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
                                        nav.path.append(locationManager)
                                    } label: {
                                        Image(systemName: "magnifyingglass")
                                            .font(.system(size: 18))
                                            .fontWeight(.bold)
                                            .foregroundStyle(Color("TitleColor"))
                                    }
                                }
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
                            print("on Appear Method -> latitude: \(locationManager.lastLocation?.coordinate.latitude)")
                            print("on Appear Method -> longitude \(locationManager.lastLocation?.coordinate.longitude)")
                            await viewModel.getWeather(location: locationManager.lastLocation)
                        }
                    }
                    .navigationDestination(for: DailyWeatherModel.self) { day in
                        DayDetailView(day: day)
                    }
                    .navigationDestination(isPresented: $goToSettings) {
                        SettingsView(settings: $viewModel.settings)
                    }
                    .navigationDestination(for: LocationManager.self) { locationManager in
                        SearchView(locationManager: locationManager)
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
//        .preferredColorScheme(viewModel.settings.appearance.colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationStateManager())
    }
}
