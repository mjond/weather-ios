//
//  HomeModel.swift
//  Weather
//
//  Created by Mark Davis on 10/22/24.
//

import Foundation

struct HomeModel: Equatable {
    var locationName: String
    var currentTemperature: String
    var apparentTemperature: String
    var currentSunrise: Date
    var currentSunset: Date
    var currentWeatherCode: Int
    var currentWeatherIconName: String {
        WeatherHelper().getCurrentWeatherCodeIcon(from: currentWeatherCode, sunrise: currentSunrise, sunset: currentSunset)
    }
    var currentWindSpeed: String
    var currentWindGust: String
    var currentWindDirectionDegrees: String
    var currentUvIndex: String
    var currentPrecipitationAmount: String
    var dailyForecast: [DailyWeatherModel]
    var hourlyForecast: [HourlyWeatherModel]
}

struct DailyWeatherModel: Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var abbreviatedDayName: String {
        return date.formatted(Date.FormatStyle().weekday(.abbreviated))
    }
    var fullDayName: String {
        return date.formatted(Date.FormatStyle().weekday(.wide))
    }
    var minimumTemperature: String
    var maximumTemperature: String
    var weatherCode: Int
    var weatherIconName: String {
        WeatherHelper().getDailyWeatherCodeIcon(from: weatherCode)
    }
    var precipitationProbability: String
    var precipitationAmount: String
    var uvIndexMax: String
    var sunset: Date
    var sunrise: Date
    var windSpeed: String
    var windGust: String
    var windDirectionDegrees: String
}

struct HourlyWeatherModel: Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var temperature: String
    var weatherCode: Int
    var isDay: Int
    var weatherIconName: String {
        WeatherHelper().getHourlyWeatherCodeIcon(weatherCode, isDay)
    }
}
