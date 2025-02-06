//
//  WeatherHelperTests.swift
//  Weather
//
//  Created by Mark Davis on 2/6/25.
//

import XCTest
@testable import Weather

final class WeatherHelperTests: XCTestCase {
    func testGetCurrentWeatherCodeIcon() {
        let helper = WeatherHelper()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let fixedSunriseDate = dateFormatter.date(from: "2025-01-15T05:23") {
            let sunrise = fixedSunriseDate.addingTimeInterval(-3600)
            let sunset = Date().addingTimeInterval(3600)
            
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 0, sunrise: sunrise, sunset: sunset), "sun.max")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 1, sunrise: sunrise, sunset: sunset), "cloud.sun")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 2, sunrise: sunrise, sunset: sunset), "cloud.sun")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 3, sunrise: sunrise, sunset: sunset), "cloud")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 45, sunrise: sunrise, sunset: sunset), "cloud.fog")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 51, sunrise: sunrise, sunset: sunset), "cloud.drizzle")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 53, sunrise: sunrise, sunset: sunset), "cloud.drizzle")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 55, sunrise: sunrise, sunset: sunset), "cloud.drizzle")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 56, sunrise: sunrise, sunset: sunset), "cloud.sleet")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 57, sunrise: sunrise, sunset: sunset), "cloud.sleet")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 61, sunrise: sunrise, sunset: sunset), "cloud.rain")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 63, sunrise: sunrise, sunset: sunset), "cloud.rain")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 65, sunrise: sunrise, sunset: sunset), "cloud.rain")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 71, sunrise: sunrise, sunset: sunset), "cloud.snow")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 73, sunrise: sunrise, sunset: sunset), "cloud.snow")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 75, sunrise: sunrise, sunset: sunset), "cloud.snow")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 77, sunrise: sunrise, sunset: sunset), "cloud.snow")
            XCTAssertEqual(helper.getCurrentWeatherCodeIcon(from: 95, sunrise: sunrise, sunset: sunset), "cloud.bolt.rain")
        }
    }
        
    func testGetDailyWeatherCodeIcon() {
        let helper = WeatherHelper()
        
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 0), "sun.max")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 1), "cloud.sun")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 2), "cloud.sun")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 3), "cloud")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 45), "cloud.fog")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 51), "cloud.drizzle")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 61), "cloud.rain")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 71), "cloud.snow")
        XCTAssertEqual(helper.getDailyWeatherCodeIcon(from: 95), "cloud.bolt.rain")
    }
    
    func testGetHourlyWeatherCodeIcon() {
        let helper = WeatherHelper()
        
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(0, 1), "sun.max")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(0, 0), "moon")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(1, 1), "cloud.sun")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(1, 0), "cloud.moon")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(3, 1), "cloud")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(45, 1), "cloud.fog")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(51, 1), "cloud.drizzle")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(61, 1), "cloud.rain")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(71, 1), "cloud.snow")
        XCTAssertEqual(helper.getHourlyWeatherCodeIcon(95, 1), "cloud.bolt.rain")
    }
}
