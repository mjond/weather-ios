//
//  WeatherServiceMock.swift
//  Weather
//
//  Created by Mark Davis on 1/4/25.
//

@testable import Weather
import Foundation

struct MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError: Bool = false
    var mockWeatherData: WeatherDataModel? = mockData

    func getWeather(latitude: String, longitude: String, unit: Weather.UnitOfMeasurement) async throws -> Weather.WeatherDataModel? {
        if shouldReturnError {
            throw NSError(domain: "MockWeatherService", code: -1, userInfo: nil)
        }
        
        return mockWeatherData
    }
}
