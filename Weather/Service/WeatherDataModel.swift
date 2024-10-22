//
//  WeatherModel.swift
//  Weather
//
//  Created by Mark Davis on 11/8/23.
//

import Foundation

struct WeatherDataModel: Codable {
    var current: Current
}

struct Current: Codable {
    let time: String
    let temperature: Double
    let weatherCode: Double
    
    init(time: String, temperature: Double, weatherCode: Double) {
        self.time = time
        self.temperature = temperature
        self.weatherCode = weatherCode
    }
    
    init() {
        time = ""
        temperature = 0.0
        weatherCode = 0.0
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
