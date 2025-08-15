//
//  MockWeatherService.swift
//  Weather
//
//  Created by Mark Davis on 1/4/25.
//

import Foundation
@testable import Weather

struct MockWeatherService: WeatherServiceProtocol {
    var shouldReturnError: Bool = false
    var mockWeatherData: WeatherDataModel? = mockData

    func getWeather(latitude _: String, longitude _: String, unit _: Weather.UnitOfMeasurement) async throws -> Weather.WeatherDataModel? {
        if shouldReturnError {
            throw NSError(domain: "MockWeatherService", code: -1, userInfo: nil)
        }

        return mockWeatherData
    }

    mutating func setCacheManager(_: Weather.WeatherCacheManager) {
        // not needed for unit tests
    }
}
