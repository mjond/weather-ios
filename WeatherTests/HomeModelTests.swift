//
//  HomeModelTests.swift
//  Weather
//
//  Created by Mark Davis on 2/6/25.
//

@testable import Weather
import XCTest

final class HomeModelTests: XCTestCase {
    func testHomeModelInitialization() {
        let now = Date()
        let dailyForecast = [
            DailyWeatherModel(date: now, minimumTemperature: "10", maximumTemperature: "20", weatherCode: 48,
                              precipitationProbability: "30", precipitationAmount: "5", uvIndexMax: "8",
                              sunset: now, sunrise: now, windSpeed: "10", windGust: "20", windDirectionDegrees: "180")
        ]
        let hourlyForecast = [
            HourlyWeatherModel(date: now, temperature: "15", weatherCode: 48, isDay: 1)
        ]
        let homeModel = HomeModel(locationName: "New York", currentTemperature: "22",
                                  apparentTemperature: "21", currentSunrise: now, currentSunset: now,
                                  currentWeatherCode: 48, currentWindSpeed: "10", currentWindGust: "15",
                                  currentWindDirectionDegrees: "180", currentUvIndex: "5",
                                  currentPrecipitationAmount: "2",
                                  dailyForecast: dailyForecast, hourlyForecast: hourlyForecast)

        XCTAssertEqual(homeModel.locationName, "New York")
        XCTAssertEqual(homeModel.currentTemperature, "22")
        XCTAssertEqual(homeModel.apparentTemperature, "21")
        XCTAssertEqual(homeModel.currentWeatherCode, 48)
        XCTAssertEqual(homeModel.currentWeatherIconName, "cloud.fog")
        XCTAssertEqual(homeModel.currentWindSpeed, "10")
        XCTAssertEqual(homeModel.currentWindGust, "15")
        XCTAssertEqual(homeModel.currentWindDirectionDegrees, "180")
        XCTAssertEqual(homeModel.currentUvIndex, "5")
        XCTAssertEqual(homeModel.currentPrecipitationAmount, "2")
        XCTAssertEqual(homeModel.dailyForecast.count, 1)
        XCTAssertEqual(homeModel.hourlyForecast.count, 1)
    }

    func testDailyWeatherModelInitialization() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let fixedDate = dateFormatter.date(from: "2025-01-15T05:23") {
            let dailyWeather = DailyWeatherModel(date: fixedDate, minimumTemperature: "10", maximumTemperature: "20", weatherCode: 48,
                                                 precipitationProbability: "30", precipitationAmount: "5", uvIndexMax: "8",
                                                 sunset: fixedDate, sunrise: fixedDate, windSpeed: "10", windGust: "20", windDirectionDegrees: "180")

            XCTAssertEqual(dailyWeather.minimumTemperature, "10")
            XCTAssertEqual(dailyWeather.maximumTemperature, "20")
            XCTAssertEqual(dailyWeather.weatherCode, 48)
            XCTAssertEqual(dailyWeather.weatherIconName, "cloud.fog")
            XCTAssertEqual(dailyWeather.precipitationProbability, "30")
            XCTAssertEqual(dailyWeather.precipitationAmount, "5")
            XCTAssertEqual(dailyWeather.uvIndexMax, "8")
            XCTAssertEqual(dailyWeather.windSpeed, "10")
            XCTAssertEqual(dailyWeather.windGust, "20")
            XCTAssertEqual(dailyWeather.windDirectionDegrees, "180")
            XCTAssertEqual(dailyWeather.fullDayName, "Wednesday")
            XCTAssertEqual(dailyWeather.abbreviatedDayName, "Wed")
        }
    }

    func testHourlyWeatherModelInitialization() {
        let now = Date()
        let hourlyWeather = HourlyWeatherModel(date: now, temperature: "15", weatherCode: 48, isDay: 1)

        XCTAssertEqual(hourlyWeather.temperature, "15")
        XCTAssertEqual(hourlyWeather.weatherCode, 48)
        XCTAssertEqual(hourlyWeather.weatherIconName, "cloud.fog")
        XCTAssertEqual(hourlyWeather.isDay, 1)
    }
}
