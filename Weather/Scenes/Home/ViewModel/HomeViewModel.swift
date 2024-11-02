//
//  HomeViewModel.swift
//  Weather
//
//  Created by Mark Davis on 10/21/24.
//

import SwiftUI
import CoreLocation

class HomeViewModel: ObservableObject {
    @Published var state = State.loading
    private var locationManager = LocationManager()
    
    var userLatitude: String {
        if let latitude = locationManager.lastLocation?.coordinate.latitude {
            return String(format: "%.3f", latitude)
        }
        return "0.00"
    }

    var userLongitude: String {
        if let longitude = locationManager.lastLocation?.coordinate.longitude {
            return String(format: "%.3f", longitude)
        }
        return "0.00"
    }

    var isAPICallInProgress = false

    enum State {
        case loading
        case failure
        case success(HomeModel)
    }

    func getWeather() async {
        guard !isAPICallInProgress else { return }
        isAPICallInProgress = true
        
        DispatchQueue.main.async {
            self.state = .loading
        }

        do {
            if let weatherData = try await WeatherService().getWeather(latitude: userLatitude, longitude: userLongitude) {
                let currentTemperature = String(format: "%.0f", weatherData.current.temperature.rounded())
                let weatherCode = Int(weatherData.current.weatherCode)
                let apparentTemperature = String(format: "%.0f", weatherData.current.apparentTemperature.rounded())
                let dailyWeather = parseDailyWeatherData(with: weatherData.daily)
                let hourlyWeather = parseHourlyWeatherData(with: weatherData.hourly)
                let locationName = await getLocationName(location: locationManager.lastLocation)

                let homeModel = HomeModel(locationName: locationName,
                                          currentTemperature: currentTemperature,
                                          apparentTemperature: apparentTemperature,
                                          currentWeatherCode: weatherCode,
                                          dailyForecast: dailyWeather,
                                          hourlyForecast: hourlyWeather)

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

    private func getLocationName(location: CLLocation?) async -> String {
        return await withCheckedContinuation { continuation in
            if let currentLocation = locationManager.lastLocation {
                currentLocation.fetchCity(completion: { city, error in
                    guard error == nil else {
                        print("getLocationName() -> Error when getting location name")
                        continuation.resume(returning: "Current Location")
                        return
                    }

                    guard let city = city else {
                        print("getLocationName() -> No location found")
                        continuation.resume(returning: "Current Location")
                        return
                    }
                    continuation.resume(returning: city)
                })
            }
        }
    }
    
    private func parseDailyWeatherData(with response: DailyWeatherData) -> [DailyWeatherModel] {
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
            guard let sunrise = getDateAndTimeFromString(response.sunrise[index]) else { return dailyForecast }
            guard let sunset = getDateAndTimeFromString(response.sunset[index]) else { return dailyForecast }

            let minTemp = response.temperature_2m_min[index].rounded()
            let maxTemp = response.temperature_2m_max[index].rounded()
            let weatherCode = Int(response.weather_code[index])
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
                                                       uvIndexMax: formattedUv,
                                                       sunset: sunset,
                                                       sunrise: sunrise)
            
            dailyForecast.append(dailyWeatherObject)
        }
        
        return dailyForecast
    }
    
    private func parseHourlyWeatherData(with response: HourlyWeatherData) -> [HourlyWeatherModel] {
        var hourlyForecast: [HourlyWeatherModel] = []
        
        guard response.time.count > 0,
              response.temperature_2m.count > 0,
              response.weather_code.count > 0,
              response.is_day.count > 0
        else {
            return hourlyForecast
        }

        // The hourly data comes back with 4 days worth of data, for all 24 hours of each day,
        // so find the index that is closest to the current time, and then take the next 24 hours
        // for the hourly view.
        let startingIndex = findStartingHourlyIndex(from: response)
        let endingIndex = startingIndex + 24
        
        for index in startingIndex...endingIndex {
            let dateStamp = response.time[index]
            guard let date = getDateAndTimeFromString(dateStamp) else { return hourlyForecast }

            let temp = response.temperature_2m[index].rounded()
            let weatherCode = Int(response.weather_code[index])
            let isDay = Int(response.is_day[index])

            let formattedTemp = String(format: "%.0f", temp)

            let hourlyForecastObject = HourlyWeatherModel(date: date,
                                                          temperature: formattedTemp,
                                                          weatherCode: weatherCode,
                                                          isDay: isDay)

            hourlyForecast.append(hourlyForecastObject)
        }
        return hourlyForecast
    }
    
    private func findStartingHourlyIndex(from hours: HourlyWeatherData) -> Int {
        let currentDate = Date()

        for (index, dateStamp) in hours.time.enumerated() {
            guard let date = getDateAndTimeFromString(dateStamp) else { return 0 }

            if date < currentDate {
                guard let nextDate = getDateAndTimeFromString(hours.time[index+1]) else {
                    print("no other dates to compare ")
                    return 0
                }
                
                if nextDate > currentDate {
                    return index
                }
            }
        }
        return 0
    }

    private func getDateFromString(_ dateAsString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let newDate = dateFormatter.date(from: dateAsString) {
            return newDate
        }
        return nil
    }
    
    private func getDateAndTimeFromString(_ dateAsString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let date = dateFormatter.date(from: dateAsString) {
            print(date)
            return date
        }
        return nil
    }

}
