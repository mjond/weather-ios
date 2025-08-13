//
//  HomeViewModel.swift
//  Weather
//
//  Created by Mark Davis on 10/21/24.
//

import SwiftUI
import CoreLocation

class HomeViewModel: ObservableObject {
    @Published var state = ViewState.loading
    private var settings: WeatherSettingsProtocol
    private var weatherService: WeatherServiceProtocol
    private var dateProvider: DateProviderProtocol
    private var isAPICallInProgress = false

    init(settings: any WeatherSettingsProtocol = WeatherSettings.shared,
         weatherService: WeatherServiceProtocol = WeatherService(),
         dateProvider: DateProviderProtocol = DateProvider()) {
        self.settings = settings
        self.weatherService = weatherService
        self.dateProvider = dateProvider
    }

    enum ViewState: Equatable {
        case loading
        case failure
        case success(HomeModel)
    }

    func getWeather(location: CLLocation?) async {
        guard !isAPICallInProgress else {
            print("HomeViewModel.getWeather() call already in progress")
            return
        }

        isAPICallInProgress = true

        await MainActor.run {
            self.state = .loading
        }

        do {
            guard let latitude = location?.coordinate.latitude else {
                isAPICallInProgress = false
                print("HomeViewModel.getWeather() no latitude value found")
                return
            }

            guard let longitude = location?.coordinate.longitude else {
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
                let locationName = await getLocationName(location: location)
                
                let currentSunrise = dailyWeather[0].sunrise
                let currentSunset = dailyWeather[0].sunset
                let currentWindSpeed = dailyWeather[0].windSpeed
                let currentWindGust = dailyWeather[0].windGust
                let currentWindDirectionDegrees = dailyWeather[0].windDirectionDegrees
                let currentUvIndex = dailyWeather[0].uvIndexMax
                let currentPrecipitationAmount = dailyWeather[0].precipitationAmount

                let homeModel = HomeModel(locationName: locationName,
                                          currentTemperature: currentTemperature,
                                          apparentTemperature: apparentTemperature,
                                          currentSunrise: currentSunrise,
                                          currentSunset: currentSunset,
                                          currentWeatherCode: weatherCode,
                                          currentWindSpeed: currentWindSpeed,
                                          currentWindGust: currentWindGust,
                                          currentWindDirectionDegrees: currentWindDirectionDegrees,
                                          currentUvIndex: currentUvIndex,
                                          currentPrecipitationAmount: currentPrecipitationAmount,
                                          dailyForecast: dailyWeather,
                                          hourlyForecast: hourlyWeather)

                await MainActor.run {
                    self.isAPICallInProgress = false
                    self.state = .success(homeModel)
                }
            }
        } catch {
            await MainActor.run {
                self.isAPICallInProgress = false
                self.state = .failure
            }
            print("HomeViewModel.getWeather() -> failed to get weather data")
        }
        
        isAPICallInProgress = false
    }

    private func getLocationName(location: CLLocation?) async -> String {
        return await withCheckedContinuation { continuation in
            if let currentLocation = location {
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

        guard response.time.count >= 10,
              response.weather_code.count >= 10,
              response.temperature_2m_min.count >= 10,
              response.temperature_2m_max.count >= 10,
              response.sunrise.count >= 10,
              response.sunset.count >= 10,
              response.precipitation_probability_mean.count >= 10,
              response.precipitation_sum.count >= 10,
              response.uv_index_max.count >= 10 else {
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
            let windGusts = response.wind_gusts_10m_max[index].rounded()
            let windDegrees = response.wind_direction_10m_dominant[index]
            
            let windDirectionWithDegrees = DirectionHelper.getDirectionWithDegrees(from: windDegrees)

            let formattedMinTemp = String(format: "%.0f", minTemp)
            let formattedMaxTemp = String(format: "%.0f", maxTemp)
            let formattedPrecipitation = getFormattedPrecipitation(precipitationAmount: precipitationAmount)
            let formattedPrecipitationProbability = String(format: "%.0f", precipitationProbability)
            let formattedUv = String(format: "%.0f", uvIndex)
            let formattedWindSpeed = getFormattedWind(from: windSpeed)
            let formattedWindGusts = getFormattedWind(from: windGusts)
            let formattedWindDirectionDegrees = windDirectionWithDegrees
            
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
                                                       windGust: formattedWindGusts,
                                                       windDirectionDegrees: formattedWindDirectionDegrees)
            
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
                formattedPrecipitationWithUnits = "<1 inch"
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
        let currentDate = dateProvider.currentDate()

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
