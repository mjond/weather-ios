//
//  WeatherService.swift
//  Weather
//
//  Created by Mark Davis on 10/21/24.
//

import Foundation

protocol WeatherServiceProtocol {
    func getWeather() async throws -> WeatherModel?
}

struct WeatherService {
    func getWeather() async throws -> WeatherModel? {
        if let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.521&longitude=13.41&current=temperature_2m,weather_code&daily=temperature_2m_min,temperature_2m_max&timezone=auto") {

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(WeatherModel.self, from: data)
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
        return WeatherModel(current: Current())
    }
}
