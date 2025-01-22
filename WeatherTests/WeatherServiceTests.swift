//
//  WeatherServiceTests.swift
//  WeatherTests
//
//  Created by Mark Davis on 1/21/25.
//

@testable import Weather
import XCTest

final class WeatherServiceTests: XCTestCase {
    func testGetWeatherSuccessfulResponse() async throws {
        let mockURLSession = MockURLSession()
        let weatherService = WeatherService(urlSession: mockURLSession)
        let mockData = mockSuccessfulJsonData
        
        mockURLSession.data = mockData
        let result = try await weatherService.getWeather(latitude: "37.7749", longitude: "-122.4194", unit: .metric)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.current.time, "2025-01-21T19:45")
        XCTAssertEqual(result?.current.temperature, -19.6)
        XCTAssertEqual(result?.current.apparentTemperature, -25.2)
        XCTAssertEqual(result?.current.weatherCode, 3.0)
        XCTAssertEqual(result?.daily.time.count, 10)
        XCTAssertEqual(result?.hourly.time.count, 240)
    }
    
    func testGetWeatherNetworkError() async throws {
        let mockURLSession = MockURLSession()
        mockURLSession.error = URLError(.notConnectedToInternet)
        let weatherService = WeatherService(urlSession: mockURLSession)

        do {
            _ = try await weatherService.getWeather(latitude: "37.7749", longitude: "-122.4194", unit: .metric)
            XCTFail("Expected network error, but succeeded.")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .notConnectedToInternet)
        }
    }
    
    func testGetWeatherInvalidJSON() async throws {
        let mockURLSession = MockURLSession()
        let invalidJSONData = "{ invalid JSON }".data(using: .utf8)
        mockURLSession.data = invalidJSONData
        let weatherService = WeatherService(urlSession: mockURLSession)

        do {
            _ = try await weatherService.getWeather(latitude: "37.7749", longitude: "-122.4194", unit: .metric)
        } catch {
            XCTAssert(error is DecodingError)
        }
    }
}
