//
//  WeatherModel.swift
//  Weather
//
//  Created by Mark Davis on 11/8/23.
//

import Foundation

struct WeatherDataModel: Codable {
    var current: CurrentWeatherData
    var daily: DailyWeatherData
    var hourly: HourlyWeatherData
}

struct CurrentWeatherData: Codable {
    let time: String
    let temperature: Double
    let weatherCode: Double
    
    init(time: String, temperature: Double, weatherCode: Double) {
        self.time = time
        self.temperature = temperature
        self.weatherCode = weatherCode
    }
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature = "temperature_2m"
        case weatherCode = "weather_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        time = try values.decodeIfPresent(String.self, forKey: .time) ?? ""
        temperature = try values.decodeIfPresent(Double.self, forKey: .temperature) ?? 0.0
        weatherCode = try values.decodeIfPresent(Double.self, forKey: .weatherCode) ?? 0.0
    }
}

struct DailyWeatherData: Codable {
    let time: [String]
    let temperature_2m_min: [Double]
    let temperature_2m_max: [Double]
    let weather_code: [Double]
    let sunrise: [String]
    let sunset: [String]
    let precipitation_probability_mean: [Double]
    let precipitation_sum: [Double]
    let uv_index_max: [Double]
}

struct HourlyWeatherData: Codable {
    let time: [String]
    let temperature_2m: [Double]
    let is_day: [Double]
    let weather_code: [Double]
}
