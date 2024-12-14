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
    @Environment(\.scenePhase) var scenePhase
    @State private var goToSettings: Bool = false
    @State private var scrollOffset: CGFloat = 0
    @State var showCollapsedView: Bool = false

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
                            HomeHeaderView(weatherModel: weatherModel, offset: scrollOffset, showCollapsedView: $showCollapsedView)

                            ScrollView {
                                VStack {
                                    HStack {
                                        HStack {
                                            Text("Sunrise:")
                                                .accessibilityLabel("Sunrise")
                                                .accessibilityAddTraits(.isStaticText)
                                                .fontDesign(.serif)
                                                .foregroundStyle(Color("TitleColor"))
                                            
                                            let sunriseDate = weatherModel.currentSunrise
                                            let sunriseTimeComponent = Calendar.current.dateComponents([.hour, .minute], from: sunriseDate)
                                            
                                            Text(sunriseDate, format: .dateTime.hour().minute())
                                                .accessibilityLabel(DateComponentsFormatter.localizedString(from: sunriseTimeComponent, unitsStyle: .spellOut) ?? "\(weatherModel.currentSunrise)")
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
                                            let sunsetTimeComponent = Calendar.current.dateComponents([.hour, .minute], from: sunsetDate)
                                            
                                            Text(sunsetDate, format: .dateTime.hour().minute())
                                                .accessibilityLabel(DateComponentsFormatter.localizedString(from: sunsetTimeComponent, unitsStyle: .spellOut) ?? "\(weatherModel.currentSunset)")
                                                .accessibilityAddTraits(.isStaticText)
                                                .fontDesign(.serif)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color("TitleColor"))
                                        }
                                    }
                                    .padding(.bottom, 20)
                                    
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
                                                    .padding(.horizontal, 3)
                                                }
                                            }
                                        } //: ScrollView
                                        .padding(.horizontal)
                                        .padding(.bottom, 30)
                                        
                                        Text("10 day forecast")
                                            .accessibilityLabel("10 day forecast")
                                            .accessibilityAddTraits(.isStaticText)
                                            .font(.callout)
                                            .fontDesign(.serif)
                                            .bold()
                                            .foregroundStyle(Color("TitleColor"))
                                            .padding(.leading, 15)
                                        
                                        VStack {
                                            ForEach(weatherModel.dailyForecast) { day in
                                                Divider()
                                                    .foregroundStyle(Color("TitleColor"))
                                                
                                                Button {
                                                    nav.path.append(day)
                                                } label: {
                                                    DayRowView(dayName: day.fullDayName,
                                                               maxTemp: day.maximumTemperature,
                                                               minTemp: day.minimumTemperature,
                                                               weatherIconName: day.weatherIconName)
                                                    .accessibilityAddTraits(.isButton)
                                                    .accessibilityHint("This button will take you to this day's detail view")
                                                    .frame(minHeight: 40)
                                                    .padding(.leading, 5)
                                                }
                                            }
                                            Divider()
                                                .foregroundStyle(Color("TitleColor"))
                                            
                                        } //: VStack
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 25)
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
                                .toolbarBackground(Color("BackgroundColor"))
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
                                .background(GeometryReader { geometry in
                                    Color.clear.onChange(of: geometry.frame(in: .global).minY) { value in
                                        // Track scroll position
                                        scrollOffset = value
                                        DispatchQueue.main.async {
                                            withAnimation {
                                                showCollapsedView = value < 170
                                            }
                                        }
                                    }
                                })
                            } //: ScrollView
                            .scrollIndicators(.hidden)
                        }
                    } //: VStack
                    .background(Color("BackgroundColor"))
                    .task {
                        if locationManager.lastLocation != nil {
                            await viewModel.getWeather(location: locationManager.lastLocation)
                        }
                    }
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .active {
                            if locationManager.lastLocation != nil {
                                Task {
                                    await viewModel.getWeather(location: locationManager.lastLocation)
                                }
                            }
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(NavigationStateManager())
    }
}
