//
//  WeatherDataModelTests.swift
//  WeatherTests
//
//  Created by Mark Davis on 1/21/25.
//

@testable import Weather
import XCTest

final class WeatherDataModelTests: XCTestCase {
    func testSuccessfulJsonResponse() throws {
        let json = mockSuccessfulJsonData

        let decodedModel = try JSONDecoder().decode(WeatherDataModel.self, from: json)

        XCTAssertEqual(decodedModel.current.time, "2025-01-21T19:45")
        XCTAssertEqual(decodedModel.current.temperature, -19.6)
        XCTAssertEqual(decodedModel.current.weatherCode, 3.0)
        XCTAssertEqual(decodedModel.current.apparentTemperature, -25.2)
        XCTAssertEqual(decodedModel.daily.time.count, 10)
        XCTAssertEqual(decodedModel.hourly.time.count, 240)
    }

    func testDecodingWithEmptyData() throws {
        let json = mockJsonDataWithEmptyValues

        let decodedModel = try JSONDecoder().decode(WeatherDataModel.self, from: json)

        XCTAssertEqual(decodedModel.current.time, "")
        XCTAssertEqual(decodedModel.current.weatherCode, 0.0)
        XCTAssertEqual(decodedModel.current.temperature, 0.0)
        XCTAssertEqual(decodedModel.current.apparentTemperature, 0.0)
    }
}
