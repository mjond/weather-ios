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

        guard response.time.count == 7,
              response.weather_code.count == 7,
              response.temperature_2m_min.count == 7,
              response.temperature_2m_max.count == 7,
              response.sunrise.count == 7,
              response.sunset.count == 7,
              response.precipitation_probability_mean.count == 7,
              response.precipitation_sum.count == 7,
              response.uv_index_max.count == 7 else {
            return dailyForecast
        }
        
        for (index, dateStamp) in response.time.enumerated() {
            guard let date = getDateFromString(dateStamp) else { return dailyForecast }

            let minTemp = response.temperature_2m_min[index].rounded()
            let maxTemp = response.temperature_2m_max[index].rounded()
            let weatherCode = Int(response.weather_code[index].rounded())
            let precipitationProbability = String(response.precipitation_probability_mean[index])
            let precipitationAmount = response.precipitation_sum[index].rounded()
            let uvIndex = response.uv_index_max[index].rounded()

            let formattedMinTemp = String(format: "%.0f", minTemp)
            let formattedMaxTemp = String(format: "%.0f", maxTemp)
            let formattedPrecipitationAmount = String(format: "%.0f", precipitationAmount)
            let formattedUv = String(format: "%.0f", uvIndex)
            
            let dailyWeatherObject = DailyWeatherModel(date: date,
                                                       minimumTemperature: formattedMinTemp,
                                                       maximumTemperature: formattedMaxTemp,
                                                       weatherCode: weatherCode,
                                                       precipitationProbability: precipitationProbability,
                                                       precipitationAmount: formattedPrecipitationAmount,
                                                       uvIndexMax: formattedUv)
            
            dailyForecast.append(dailyWeatherObject)
        }
        
        return dailyForecast
    }

    private func getDateFromString(_ dateAsString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let newDate = dateFormatter.date(from: dateAsString) {
            print(newDate)
            return newDate
        }
        return nil
    }
}
