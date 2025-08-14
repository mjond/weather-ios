//
//  WeatherService.swift
//  Weather
//
//  Created by Mark Davis on 10/21/24.
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

protocol WeatherServiceProtocol {
    func getWeather(latitude: String, longitude: String, unit: UnitOfMeasurement) async throws -> WeatherDataModel?
    mutating func setCacheManager(_ cacheManager: WeatherCacheManager)
}

struct WeatherService: WeatherServiceProtocol {
    private let urlSession: URLSessionProtocol
    private var cacheManager: WeatherCacheManager?
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    mutating func setCacheManager(_ cacheManager: WeatherCacheManager) {
        self.cacheManager = cacheManager
    }
    
    func getWeather(latitude: String, longitude: String, unit: UnitOfMeasurement) async throws -> WeatherDataModel? {
        let lat = Double(latitude) ?? 0.0
        let lon = Double(longitude) ?? 0.0
        
        // 1. Check cache first (if available)
        if let cacheManager = cacheManager,
           let cachedWeather = cacheManager.getCachedWeather(latitude: lat, longitude: lon, unit: unit) {
            print("WeatherService.getWeather() -> returning cached weather data")
            return cachedWeather
        }
        
        // 2. Fetch from API
        guard let weatherData = try await fetchFromAPI(latitude: latitude, longitude: longitude, unit: unit) else {
            return nil
        }
        
        // 3. Save to cache (if available)
        if let cacheManager = cacheManager {
            do {
                try cacheManager.saveWeather(weatherData, latitude: lat, longitude: lon, unit: unit)
                print("WeatherService.getWeather() -> saved weather data to cache")
            } catch {
                print("WeatherService.getWeather() -> failed to save to cache: \(error)")
            }
        }
        
        return weatherData
    }
    
    private func fetchFromAPI(latitude: String, longitude: String, unit: UnitOfMeasurement) async throws -> WeatherDataModel? {
        var unitOfMeasurement = "fahrenheit"
        if unit == .metric {
            unitOfMeasurement = "celsius"
        }

        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?current=temperature_2m,weather_code,apparent_temperature&daily=temperature_2m_min,temperature_2m_max,weather_code,sunrise,sunset,precipitation_probability_mean,precipitation_sum,uv_index_max,wind_direction_10m_dominant,wind_speed_10m_max,wind_gusts_10m_max&timezone=auto&latitude=\(latitude)&longitude=\(longitude)&forecast_days=10&temperature_unit=\(unitOfMeasurement)&hourly=temperature_2m,is_day,weather_code") else {
            return nil
        }

        do {
            let (data, _) = try await self.urlSession.data(from: url)
            let response = try JSONDecoder().decode(WeatherDataModel.self, from: data)
            return response
        } catch let error as DecodingError {
            print("WeatherService.fetchFromAPI() -> failed to fetch weather data with error: \(error)")
            throw error
        }
    }
}
