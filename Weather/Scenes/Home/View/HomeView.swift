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
                                        .accessibilityLabel("\(weatherModel.locationName)")
                                        .accessibilityAddTraits(.isStaticText)
                                        .font(.system(size: 30))
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("TitleColor"))
                                        .padding(.bottom, 2)

                                    Text(weatherModel.currentTemperature+"°")
                                        .accessibilityLabel("\(weatherModel.currentTemperature)")
                                        .accessibilityAddTraits(.isStaticText)
                                        .font(.system(size: 46))
                                        .fontWeight(.bold)
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("TitleColor"))
                                    
                                    Text("Feels like \(weatherModel.apparentTemperature)°")
                                        .accessibilityLabel("Feels like \(weatherModel.apparentTemperature)")
                                        .accessibilityAddTraits(.isStaticText)
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("SubheadingColor"))
                                        .padding(.bottom, 5)

                                    Image(systemName: weatherModel.currentWeatherIconName)
                                        .accessibilityLabel("\(weatherModel.currentWeatherIconName)")
                                        .accessibilityAddTraits(.isStaticText)
                                        .font(.system(size: 80))
                                        .fontDesign(.serif)
                                        .foregroundStyle(Color("TitleColor"))
                                        .padding(.bottom)
                                    
                                    HStack {
                                        HStack {
                                            Text("Sunrise:")
                                                .accessibilityLabel("Sunrise")
                                                .accessibilityAddTraits(.isStaticText)
                                                .fontDesign(.serif)
                                                .foregroundStyle(Color("TitleColor"))
                                            let sunriseDate = weatherModel.currentSunrise
                                            Text(sunriseDate, format: .dateTime.hour().minute())
                                                .accessibilityLabel("\(weatherModel.currentSunrise)")
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
                                            let sunsetDate = weatherModel.currentSunset
                                            Text(sunsetDate, format: .dateTime.hour().minute())
                                                .accessibilityLabel("\(weatherModel.currentSunset)")
                                                .accessibilityAddTraits(.isStaticText)
                                                .fontDesign(.serif)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color("TitleColor"))
                                        }
                                    }

                                } //: VStack
                                .padding(.bottom, 30)
                                
                                VStack(alignment: .leading) {
                                    Text("24 hour forecast")
                                        .accessibilityLabel("24 hour forecast")
                                        .accessibilityAddTraits(.isStaticText)
                                        .font(.callout)
                                        .fontDesign(.serif)
                                        .bold()
                                        .foregroundStyle(Color("TitleColor"))
                                        .padding(.leading, 15)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(weatherModel.hourlyForecast) { hour in
                                                HourlyCardView(date: hour.date,
                                                               temp: hour.temperature,
                                                               weatherIconName: hour.weatherIconName)
                                            }
                                        }
                                    } //: ScrollView
                                    .padding(.horizontal)
                                    .padding(.bottom, 25)
                                    
                                    Text("10 day forecast")
                                        .accessibilityLabel("10 day forecast")
                                        .accessibilityAddTraits(.isStaticText)
                                        .font(.callout)
                                        .fontDesign(.serif)
                                        .bold()
                                        .foregroundStyle(Color("TitleColor"))
                                        .padding(.leading, 15)
                                    
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
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }

                                Spacer()

                                Link(destination: URL(string: "https://open-meteo.com/")!, label: {
                                    Text("Data Source: Open Meteo")
                                        .accessibilityLabel("Data Source: Open Meteo")
                                        .accessibilityAddTraits(.isButton)
                                        .font(.footnote)
                                        .fontDesign(.serif)
                                        .underline()
                                })

                            } //: VStack
                            .padding(.top, 15)
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        goToSettings.toggle()
                                    } label: {
                                        Image(systemName: "gearshape.fill")
                                            .accessibilityLabel("Settings")
                                            .accessibilityAddTraits(.isButton)
                                            .font(.system(size: 18))
                                            .foregroundStyle(Color("TitleColor"))
                                    }
                                }
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        nav.path.append(locationManager)
                                    } label: {
                                        Image(systemName: "magnifyingglass")
                                            .accessibilityLabel("Search")
                                            .accessibilityAddTraits(.isButton)
                                            .font(.system(size: 18))
                                            .fontWeight(.bold)
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
