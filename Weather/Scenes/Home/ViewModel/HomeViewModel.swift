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
                let dailyWeather = parseDailyWeatherValues(with: weatherData.daily)
                let homeModel = HomeModel(currentTemperature: currentTemperature,
                                          currentWeatherCode: weatherCode,
                                          dailyForecast: dailyWeather)
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
    
    func parseDailyWeatherValues(with response: DailyWeatherData) -> [DailyWeatherModel] {
        var dailyForecast: [DailyWeatherModel] = []
        // todo: add check for number of values in each array
        for (index, date) in response.time.enumerated() {
            let minTemp = response.temperature_2m_min[index].rounded()
            let maxTemp = response.temperature_2m_max[index].rounded()
            let weatherCode = response.weather_code[index].rounded()
            
            let formattedMinTemp = String(format: "%.0f", minTemp)
            let formattedMaxTemp = String(format: "%.0f", maxTemp)
            let weatherCodeAsInt = Int(weatherCode)
            
            let dailyWeatherObject = DailyWeatherModel(date: date,
                                                       minimumTemperature: formattedMinTemp,
                                                       maximumTemperature: formattedMaxTemp,
                                                       weatherCode: weatherCodeAsInt)
            
            dailyForecast.append(dailyWeatherObject)
        }
        
        return dailyForecast
    }
}
