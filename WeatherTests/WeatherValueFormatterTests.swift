//
//  WeatherValueFormatterTests.swift
//  Weather
//
//  Created by Mark Davis on 4/21/26.
//

@testable import Weather
import XCTest

final class WeatherValueFormatterTests: XCTestCase {
    func testFormatPrecipitation_Imperial_Zero() {
        let formatted = WeatherValueFormatter.formatPrecipitation(precipitationAmount: 0, unit: .imperial)

        XCTAssertEqual(formatted, "0 inches")
    }

    func testFormatPrecipitation_Imperial_LessThanOneInch() {
        let formatted = WeatherValueFormatter.formatPrecipitation(precipitationAmount: 10, unit: .imperial)

        XCTAssertEqual(formatted, "<1 inch")
    }

    func testFormatPrecipitation_Imperial_ExactlyOneInch() {
        let formatted = WeatherValueFormatter.formatPrecipitation(precipitationAmount: 25.4, unit: .imperial)

        XCTAssertEqual(formatted, "1 inch")
    }

    func testFormatPrecipitation_Imperial_MultipleInches() {
        let formatted = WeatherValueFormatter.formatPrecipitation(precipitationAmount: 50.8, unit: .imperial)

        XCTAssertEqual(formatted, "2 inches")
    }

    func testFormatPrecipitation_Metric() {
        let formatted = WeatherValueFormatter.formatPrecipitation(precipitationAmount: 13.6, unit: .metric)

        XCTAssertEqual(formatted, "14 mm")
    }

    func testFormatWind_Imperial() {
        let formatted = WeatherValueFormatter.formatWind(from: 10, unit: .imperial)

        XCTAssertEqual(formatted, "6 mph")
    }

    func testFormatWind_Metric() {
        let formatted = WeatherValueFormatter.formatWind(from: 10.4, unit: .metric)

        XCTAssertEqual(formatted, "10 km/h")
    }
}
