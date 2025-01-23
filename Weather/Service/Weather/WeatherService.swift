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
}

struct WeatherService: WeatherServiceProtocol {
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getWeather(latitude: String, longitude: String, unit: UnitOfMeasurement) async throws -> WeatherDataModel? {
        var unitOfMeasurement = "fahrenheit"
        if unit == .metric {
            unitOfMeasurement = "celsius"
        }

        if let url = URL(string: "https://api.open-meteo.com/v1/forecast?current=temperature_2m,weather_code,apparent_temperature&daily=temperature_2m_min,temperature_2m_max,weather_code,sunrise,sunset,precipitation_probability_mean,precipitation_sum,uv_index_max,wind_direction_10m_dominant,wind_speed_10m_max,wind_gusts_10m_max&timezone=auto&latitude=\(latitude)&longitude=\(longitude)&forecast_days=10&temperature_unit=\(unitOfMeasurement)&hourly=temperature_2m,is_day,weather_code") {

            do {
                let (data, _) = try await self.urlSession.data(from: url)
                let response = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                return response
            } catch let error as DecodingError {
//                switch error {
//                case .keyNotFound(let key, let context):
//                    print("getWeather() -> Key '\(key)' not found:", context.debugDescription)
//                case .typeMismatch(let type, let context):
//                    print("getWeather() -> Type mismatch:", type, context.debugDescription)
//                case .valueNotFound(let type, let context):
//                    print("getWeather() -> Value not found:", type, context.debugDescription)
//                case .dataCorrupted(let context):
//                    print("getWeather() -> Data corrupted:", context.debugDescription)
//                @unknown default:
//                    print("getWeather() -> Unknown error when decoding weather response")
//                }
//                
                print("WeatherService.getWeather() -> failed to fetch weather data with error: \(error)")
            }
        }
        return nil
    }
}
