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

    var mockWeatherData: WeatherDataModel? = WeatherDataModel(
        current: CurrentWeatherData(
            time: "2025-01-04T12:00:00Z",
            temperature: 23.5,
            weatherCode: 1,
            apparentTemperature: 25.0
        ),
        daily: DailyWeatherData(
            time: [
                "2025-01-05", "2025-01-06", "2025-01-07", "2025-01-07", "2025-01-07", "2025-01-07", "2025-01-07", "2025-01-07", "2025-01-07", "2025-01-07"
            ],
            temperature_2m_min: [
                18.0, 16.5, 17.0, 17.0, 17.0, 17.0, 17.0, 17.0, 17.0, 17.0
            ],
            temperature_2m_max: [
                25.0, 22.0, 23.5, 23.5, 23.5, 23.5, 23.5, 23.5, 23.5, 23.5
            ],
            weather_code: [
                1, 2, 3, 1, 1, 1, 1, 1, 1, 1
            ],
            sunrise: [
                "2025-01-05T06:30:00Z", "2025-01-06T06:31:00Z", "2025-01-07T06:32:00Z", "2025-01-07T06:32:00Z", "2025-01-07T06:32:00Z", "2025-01-07T06:32:00Z", "2025-01-07T06:32:00Z", "2025-01-07T06:32:00Z", "2025-01-07T06:32:00Z", "2025-01-07T06:32:00Z"
            ],
            sunset: [
                "2025-01-05T18:30:00Z", "2025-01-06T18:31:00Z", "2025-01-07T18:32:00Z", "2025-01-07T18:32:00Z", "2025-01-07T18:32:00Z", "2025-01-07T18:32:00Z", "2025-01-07T18:32:00Z", "2025-01-07T18:32:00Z", "2025-01-07T18:32:00Z", "2025-01-07T18:32:00Z"
            ],
            precipitation_probability_mean: [
                0.1, 0.2, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3
            ],
            precipitation_sum: [
                0.0, 0.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
            ],
            uv_index_max: [
                5.0, 4.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0, 6.0
            ],
            wind_speed_10m_max: [
                15.0, 10.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0, 12.0
            ],
            wind_gusts_10m_max: [
                20.0, 15.0, 18.0, 18.0, 18.0, 18.0, 18.0, 18.0, 18.0, 18.0
            ]
        ),
        hourly: HourlyWeatherData(
            time: [
                "2025-01-05T00:00:00Z", "2025-01-05T01:00:00Z", "2025-01-05T02:00:00Z", "2025-01-05T02:00:00Z", "2025-01-05T02:00:00Z", "2025-01-05T02:00:00Z", "2025-01-05T02:00:00Z", "2025-01-05T02:00:00Z", "2025-01-05T02:00:00Z", "2025-01-05T02:00:00Z"
            ],
            temperature_2m: [
                20.0, 19.5, 19.0, 19.0, 19.0, 19.0, 19.0, 19.0, 19.0, 19.0
            ],
            is_day: [
                1, 0, 0, 0, 0, 0, 0, 0, 0, 0
            ],
            weather_code: [
                1, 2, 2, 2, 2, 2, 2, 2, 2, 2
            ]
        )
    )
    
    func getWeather(latitude: String, longitude: String, unit: Weather.UnitOfMeasurement) async throws -> Weather.WeatherDataModel? {
        if shouldReturnError {
            throw NSError(domain: "MockWeatherService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Simulated error"])
        }
        
        return mockWeatherData
    }
}
