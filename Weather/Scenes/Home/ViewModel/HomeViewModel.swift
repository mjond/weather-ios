//
//  HomeViewModel.swift
//  Weather
//
//  Created by Mark Davis on 10/21/24.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var state = State.isLoading
    var isAPICallInProgress = false
    
    enum State {
        case isLoading
        case failure
        case success(HomeModel)
    }
    
    func getWeather() async {
        guard !isAPICallInProgress else { return }
        isAPICallInProgress = true
        
        do {
            if let weatherData = try await WeatherService().getWeather() {
                print(weatherData)
                let currentTemperature = String(format: "%.0f", weatherData.current.temperature.rounded())
                let weatherCode = Int(weatherData.current.weatherCode)
                let homeModel = HomeModel(currentTemperature: currentTemperature,
                                          weatherCode: weatherCode)
                DispatchQueue.main.async {
                    self.state = .success(homeModel)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.state = .failure
            }
            print("HomeViewModel.getWeather() -> failed to get weather data")
        }
        
        isAPICallInProgress = false
    }
}
