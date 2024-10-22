//
//  WeatherService.swift
//  Weather
//
//  Created by Mark Davis on 10/21/24.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeather() async throws -> WeatherDataModel?
}

struct WeatherService {
    func getWeather() async throws -> WeatherDataModel? {
        if let url = URL(string: "https://api.open-meteo.com/v1/forecast?current=temperature_2m,weather_code&daily=temperature_2m_min,temperature_2m_max,weather_code,sunrise,sunset&timezone=auto&latitude=42.96&longitude=-85.67") {

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                return response
            } catch let error as DecodingError {
                switch error {
                case .keyNotFound(let key, let context):
                    print("Key '\(key)' not found:", context.debugDescription)
                case .typeMismatch(let type, let context):
                    print("Type mismatch:", type, context.debugDescription)
                case .valueNotFound(let type, let context):
                    print("Value not found:", type, context.debugDescription)
                case .dataCorrupted(let context):
                    print("Data corrupted:", context.debugDescription)
                }
                
                print("WeatherService.getWeather() -> failed to fetch weather data")
            }
        }
        return WeatherDataModel(current: Current())
    }
}
