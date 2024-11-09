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
    @ObservedObject var settings = WeatherSettings()
    private var locationManager = LocationManager()
    private var weatherService = WeatherService()

    var isAPICallInProgress = false

    enum State {
        case loading
        case failure
        case success(HomeModel)
    }

    func getWeather(lat: CLLocationDegrees?, long: CLLocationDegrees?) async {
        guard !isAPICallInProgress else {
            print("HomeViewModel.getWeather() call already in progress")
            return
        }

        isAPICallInProgress = true

        DispatchQueue.main.async {
            self.state = .loading
        }

        do {
            guard let latitude = lat else {
                isAPICallInProgress = false
                print("HomeViewModel.getWeather() no latitude value found")
                return
            }

            guard let longitude = long else {
                isAPICallInProgress = false
                print("HomeViewModel.getWeather() no longitude value found")
                return
            }
            
            let formattedLatitude = String(format: "%.3f", latitude)
            let formattedLongitude = String(format: "%.3f", longitude)

            if let weatherData = try await weatherService.getWeather(latitude: formattedLatitude, longitude: formattedLongitude, unit: settings.unitOfMeasurement) {
                let currentTemperature = String(format: "%.0f", weatherData.current.temperature.rounded())
                let weatherCode = Int(weatherData.current.weatherCode)
                let apparentTemperature = String(format: "%.0f", weatherData.current.apparentTemperature.rounded())
                let dailyWeather = parseDailyWeatherData(with: weatherData.daily)
                let hourlyWeather = parseHourlyWeatherData(with: weatherData.hourly)
                let locationName = await getLocationName(location: locationManager.lastLocation)
                
                let currentSunrise = dailyWeather[0].sunrise
                let currentSunset = dailyWeather[0].sunset

                let homeModel = HomeModel(locationName: locationName,
                                          currentTemperature: currentTemperature,
                                          apparentTemperature: apparentTemperature,
                                          currentSunrise: currentSunrise,
                                          currentSunset: currentSunset,
                                          currentWeatherCode: weatherCode,
                                          dailyForecast: dailyWeather,
                                          hourlyForecast: hourlyWeather)

                DispatchQueue.main.async {
                    self.isAPICallInProgress = false
                    self.state = .success(homeModel)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isAPICallInProgress = false
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
                        print("HomeViewModel.getLocationName() -> Error when getting location name")
                        continuation.resume(returning: "Current Location")
                        return
                    }

                    guard let city = city else {
                        print("HomeViewModel.getLocationName() -> No location found")
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
            let precipitationProbability = Double(response.precipitation_probability_mean[index])
            let precipitationAmount = response.precipitation_sum[index].rounded()
            let uvIndex = response.uv_index_max[index].rounded()
            let windSpeed = response.wind_speed_10m_max[index].rounded()
            let windDirection = response.wind_speed_10m_max[index]

            let formattedMinTemp = String(format: "%.0f", minTemp)
            let formattedMaxTemp = String(format: "%.0f", maxTemp)
            let formattedPrecipitation = getFormattedPrecipitation(precipitationAmount: precipitationAmount)
            let formattedPrecipitationProbability = String(format: "%.0f", precipitationProbability)
            let formattedUv = String(format: "%.0f", uvIndex)
            let formattedWindSpeed = getFormattedWind(from: windDirection)
            
            let dailyWeatherObject = DailyWeatherModel(date: date,
                                                       minimumTemperature: formattedMinTemp,
                                                       maximumTemperature: formattedMaxTemp,
                                                       weatherCode: weatherCode,
                                                       precipitationProbability: formattedPrecipitationProbability,
                                                       precipitationAmount: formattedPrecipitation,
                                                       uvIndexMax: formattedUv,
                                                       sunset: sunset,
                                                       sunrise: sunrise,
                                                       windSpeed: formattedWindSpeed,
                                                       windDirection: windDirection)
            
            dailyForecast.append(dailyWeatherObject)
        }
        
        return dailyForecast
    }
    
    private func getFormattedPrecipitation(precipitationAmount: Double) -> String {
        var formattedPrecipitationWithUnits = ""
        
        if settings.unitOfMeasurement == .imperial {
            let precipitationAmount = precipitationAmount * 0.0393701
            
            if precipitationAmount == 0 {
                formattedPrecipitationWithUnits = "0 inches"
            } else if precipitationAmount < 0.6 {
                formattedPrecipitationWithUnits = "less than 1 inch"
                print(formattedPrecipitationWithUnits)
            } else {
                let precipatationRounded = precipitationAmount.rounded()
                
                if precipatationRounded == 1.0 {
                    let precipitationAsString = String(format: "%.0f", precipatationRounded)
                    formattedPrecipitationWithUnits = precipitationAsString + " inch"
                } else {
                    let precipitationAsString = String(format: "%.0f", precipatationRounded)
                    formattedPrecipitationWithUnits = precipitationAsString + " inches"
                }
            }
        } else {
            let precipitationAsString = String(format: "%.0f", precipitationAmount)
            formattedPrecipitationWithUnits = precipitationAsString + " mm"
        }

        return formattedPrecipitationWithUnits
    }

    private func getFormattedWind(from amount: Double) -> String {
        var formattedWindWithUnits = ""
        
        if settings.unitOfMeasurement == .imperial {
            let amountAsImperial = amount * 0.6214
            formattedWindWithUnits = String(format: "%.0f", amountAsImperial)
            formattedWindWithUnits = formattedWindWithUnits + " mph"
        } else {
            formattedWindWithUnits = String(format: "%.0f", amount)
            formattedWindWithUnits = formattedWindWithUnits + " km/h"
        }
        
        return formattedWindWithUnits
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
            return date
        }
        return nil
    }

}
