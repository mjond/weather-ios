//
//  WeatherCacheManager.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//

import CoreData
import Foundation

class WeatherCacheManager {
    private let context: NSManagedObjectContext
    private let cacheExpiration: TimeInterval = 10 * 60 // 10 minutes

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func getCachedWeather(latitude: Double, longitude: Double, unit: UnitOfMeasurement) -> WeatherDataModel? {
        do {
            try clearExpiredCache()
        } catch {
            print("WeatherCacheManager.getCachedWeather -> Error clearing expired cache: \(error)")
        }

        let request: NSFetchRequest<WeatherData> = WeatherData.fetchRequest()
        let expirationDate = Date().addingTimeInterval(-cacheExpiration)
        request.predicate = NSPredicate(
            format: "latitude == %@ AND longitude == %@ AND unitOfMeasurement == %@ AND cachedAt > %@",
            argumentArray: [latitude, longitude, unit.rawValue, expirationDate as NSDate]
        )
        request.fetchLimit = 1

        guard let weatherData = try? context.fetch(request).first else { return nil }

        return convertToWeatherDataModel(weatherData)
    }

    func saveWeather(_ model: WeatherDataModel, latitude: Double, longitude: Double, unit: UnitOfMeasurement) throws {
        try context.performAndWait {
            // Clear existing cache for this location
            do {
                try clearCache(latitude: latitude, longitude: longitude, unit: unit)
            } catch {
                print("WeatherCacheManager.saveWeather -> failed to clear existing cache with error: \(error)")
            }

            // Create main weather data entity
            let weatherData = WeatherData(context: context)
            weatherData.id = UUID()
            weatherData.latitude = latitude
            weatherData.longitude = longitude
            weatherData.unitOfMeasurement = unit.rawValue
            weatherData.cachedAt = Date()

            // Create current weather
            let current = CurrentWeather(context: context)
            current.time = model.current.time
            current.temperature = model.current.temperature
            current.apparentTemperature = model.current.apparentTemperature
            current.weatherCode = Int16(model.current.weatherCode)
            current.origin = weatherData
            weatherData.currentweather = current

            // Create daily weather entries
            for index in model.daily.time.indices {
                let daily = DailyWeather(context: context)
                daily.time = model.daily.time[index]
                daily.minTemperature = model.daily.temperature_2m_min[index]
                daily.maxTemperature = model.daily.temperature_2m_max[index]
                daily.weatherCode = Int16(model.daily.weather_code[index])
                daily.sunrise = model.daily.sunrise[index]
                daily.sunset = model.daily.sunset[index]
                daily.precipitationProbabilityMean = model.daily.precipitation_probability_mean[index]
                daily.precipitationSum = model.daily.precipitation_sum[index]
                daily.uvIndexMax = model.daily.uv_index_max[index]
                daily.windSpeedMax = model.daily.wind_speed_10m_max[index]
                daily.windGustsMax = model.daily.wind_gusts_10m_max[index]
                daily.windDirectionDominant = Int16(model.daily.wind_direction_10m_dominant[index])
                daily.origin = weatherData
                weatherData.addToDailyweather(daily)
            }

            // Create hourly weather entries
            for index in model.hourly.time.indices {
                let hourly = HourlyWeather(context: context)
                hourly.time = model.hourly.time[index]
                hourly.temperature = model.hourly.temperature_2m[index]
                hourly.isDay = model.hourly.is_day[index] != 0
                hourly.weatherCode = Int16(model.hourly.weather_code[index])
                hourly.origin = weatherData
                weatherData.addToHourlyweather(hourly)
            }

            try context.save()
        }
    }

    func clearExpiredCache() throws {
        let request: NSFetchRequest<NSFetchRequestResult> = WeatherData.fetchRequest()
        let expirationDate = Date().addingTimeInterval(-cacheExpiration)
        request.predicate = NSPredicate(format: "cachedAt < %@", expirationDate as NSDate)

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
    }

    private func clearCache(latitude: Double, longitude: Double, unit: UnitOfMeasurement) throws {
        let request: NSFetchRequest<NSFetchRequestResult> = WeatherData.fetchRequest()
        request.predicate = NSPredicate(
            format: "latitude == %@ AND longitude == %@ AND unitOfMeasurement == %@",
            argumentArray: [latitude, longitude, unit.rawValue]
        )

        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        try context.execute(deleteRequest)
    }

    private func convertToWeatherDataModel(_ weatherData: WeatherData) -> WeatherDataModel {
        // Convert current weather
        let current = CurrentWeatherData(
            time: weatherData.currentweather?.time ?? "",
            temperature: weatherData.currentweather?.temperature ?? 0.0,
            weatherCode: Double(weatherData.currentweather?.weatherCode ?? 0),
            apparentTemperature: weatherData.currentweather?.apparentTemperature ?? 0.0
        )

        // Convert daily weather (from NSSet to arrays)
        let dailyArray = (weatherData.dailyweather?.allObjects as? [DailyWeather]) ?? []
        let sortedDaily = dailyArray.sorted { ($0.time ?? "") < ($1.time ?? "") }

        let daily = DailyWeatherData(
            time: sortedDaily.map { $0.time ?? "" },
            temperature_2m_min: sortedDaily.map { $0.minTemperature },
            temperature_2m_max: sortedDaily.map { $0.maxTemperature },
            weather_code: sortedDaily.map { Double($0.weatherCode) },
            sunrise: sortedDaily.map { $0.sunrise ?? "" },
            sunset: sortedDaily.map { $0.sunset ?? "" },
            precipitation_probability_mean: sortedDaily.map { $0.precipitationProbabilityMean },
            precipitation_sum: sortedDaily.map { $0.precipitationSum },
            uv_index_max: sortedDaily.map { $0.uvIndexMax },
            wind_speed_10m_max: sortedDaily.map { $0.windSpeedMax },
            wind_gusts_10m_max: sortedDaily.map { $0.windGustsMax },
            wind_direction_10m_dominant: sortedDaily.map { Double($0.windDirectionDominant) }
        )

        // Convert hourly weather
        let hourlyArray = (weatherData.hourlyweather?.allObjects as? [HourlyWeather]) ?? []
        let sortedHourly = hourlyArray.sorted { ($0.time ?? "") < ($1.time ?? "") }

        let hourly = HourlyWeatherData(
            time: sortedHourly.map { $0.time ?? "" },
            temperature_2m: sortedHourly.map { $0.temperature },
            is_day: sortedHourly.map { $0.isDay ? 1.0 : 0.0 },
            weather_code: sortedHourly.map { Double($0.weatherCode) }
        )

        return WeatherDataModel(current: current, daily: daily, hourly: hourly)
    }
}
