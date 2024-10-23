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
    @State private var showDayDetail: Bool = false
    @ObservedObject private var viewModel: HomeViewModel = HomeViewModel()

    var body: some View {
        NavigationStack(path: $nav.path) {
            VStack {
                switch viewModel.state {
                case .isLoading:
                    VStack {
                        Text("loading...")
                    }
                case .failure:
                    VStack {
                        Text("failure")
                    }
                case let .success(weatherModel):
                    VStack {
                        VStack {
                            Text("Current Weather")
                                .font(.title)
                                .padding(.bottom, 2)

                            Text(weatherModel.currentTemperature+"°")
                                .font(.system(size: 42))
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                                .padding(.bottom, 4)

                            Image(systemName: weatherModel.currentWeatherIconName)
                                .font(.system(size: 80))
                        } //: VStack
                        .padding(.bottom, 35)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(weatherModel.dailyForecast) { day in
                                    DayCardView(dayName: day.abbreviatedDayName,
                                                maxTemp: day.maximumTemperature,
                                                minTemp: day.minimumTemperature,
                                                weatherIconName: day.weatherIconName)
                                    .onTapGesture {
                                        self.showDayDetail.toggle()
                                    }
                                    .sheet(isPresented: $showDayDetail) {
                                        DayDetailView(dayName: day.fullDayName, maxTemp: day.maximumTemperature, minTemp: day.minimumTemperature, precipitationProbability: day.precipitationProbability, precipitationAmount: day.precipitationAmount, uvIndex: day.uvIndexMax, sunrise: day.sunrise, sunset: day.sunset)
                                    }
                                }
                            }
                        } //: ScrollView
                        .padding()
                        
                        Spacer()
//                        Button {
//                            nav.path.append("Settings")
//                            //                    showDetails.toggle()
//                        } label: {
//                            Text("Go to Details")
//                        }
                    } //: VStack
                    .padding(.top, 70)
//                    .navigationDestination(for: String.self) { textValue in
//                        DetailView(text: textValue)
//                    }
                }
            } //: VStack
            .task {
                await viewModel.getWeather()
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
