//
//  HomeModel.swift
//  Weather
//
//  Created by Mark Davis on 10/22/24.
//

struct HomeModel {
    var currentTemperature: String
    var currentWeatherCode: Int
    var currentWeatherIconName: String {
        switch currentWeatherCode {
        case 0:
            return "sun.max"
        case 1, 2:
            return "cloud.sun"
        case 3:
            return "cloud"
        case 45, 48:
            return "cloud.fog"
        case 51, 53, 55:
            return "cloud.drizzle"
        case 56, 57:
            return "cloud.sleet"
        case 61, 63, 65:
            return "cloud.rain"
        case 66, 67:
            return "cloud.sleet"
        case 71, 73, 75, 77:
            return "cloud.snow"
        case 80, 81, 82:
            return "cloud.rain"
        case 85, 86:
            return "cloud.snow"
        case 95, 96, 99:
            return "cloud.bolt.rain"
        default:
            return "cloud"
        }
    }
    var dailyForecast: [DailyWeatherModel]
}

struct DailyWeatherModel {
    var date: String
    var minimumTemperature: String
    var maximumTemperature: String
    var weatherCode: Int
    var weatherIconName: String {
        switch weatherCode {
        case 0:
            return "sun.max"
        case 1, 2:
            return "cloud.sun"
        case 3:
            return "cloud"
        case 45, 48:
            return "cloud.fog"
        case 51, 53, 55:
            return "cloud.drizzle"
        case 56, 57:
            return "cloud.sleet"
        case 61, 63, 65:
            return "cloud.rain"
        case 66, 67:
            return "cloud.sleet"
        case 71, 73, 75, 77:
            return "cloud.snow"
        case 80, 81, 82:
            return "cloud.rain"
        case 85, 86:
            return "cloud.snow"
        case 95, 96, 99:
            return "cloud.bolt.rain"
        default:
            return "cloud"
        }
    }
}
