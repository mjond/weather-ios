//
//  WeatherModel.swift
//  Weather
//
//  Created by Mark Davis on 11/8/23.
//

import Foundation

struct WeatherModel: Codable {
    var current: Current

//    var conditionName: String {
//        switch conditionId {
//        case 200...232:
//            return "cloud.bolt"
//        case 300...321:
//            return "cloud.drizzle"
//        case 500...531:
//            return "cloud.rain"
//        case 600...622:
//            return "cloud.snow"
//        case 701...781:
//            return "cloud.fog"
//        case 800:
//            return "sun.max"
//        case 801...804:
//            return "cloud.bolt"
//        default:
//            return "cloud"
//        }
//    }
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
