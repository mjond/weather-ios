//
//  AirQualityDataModelTests.swift
//  WeatherTests
//
//  Created by Mark Davis on 4/18/26.
//

@testable import Weather
import XCTest

final class AirQualityDataModelTests: XCTestCase {
    func testAirQualityResponseMapsGeneratedPayloadWithCurrentAndForecast() throws {
        let current = GetAirQualityQuery.Data.GetAirQuality.Current(
            time: "2026-04-18T12:00",
            usAqi: 55,
            pm10: 12.3,
            pm25: 8.7
        )
        let forecast = [
            GetAirQualityQuery.Data.GetAirQuality.Forecast(
                date: "2026-04-19",
                pm25High: 14.0,
                pm25Low: 7.0,
                pm10High: 22.0,
                pm10Low: 11.0,
                usAqiHigh: 90,
                usAqiLow: 45
            ),
        ]
        let generated = GetAirQualityQuery.Data.GetAirQuality(
            latitude: 37.7749,
            longitude: -122.4194,
            current: current,
            forecast: forecast
        )

        let response = AirQualityResponse(generated: generated)

        let latitude = try XCTUnwrap(response.latitude)
        let longitude = try XCTUnwrap(response.longitude)
        XCTAssertEqual(latitude, 37.7749, accuracy: 0.0001)
        XCTAssertEqual(longitude, -122.4194, accuracy: 0.0001)

        let mappedCurrent = try XCTUnwrap(response.current)
        XCTAssertEqual(mappedCurrent.time, "2026-04-18T12:00")
        XCTAssertEqual(mappedCurrent.usAqi, 55)
        let currentPm10 = try XCTUnwrap(mappedCurrent.pm10)
        let currentPm25 = try XCTUnwrap(mappedCurrent.pm25)
        XCTAssertEqual(currentPm10, 12.3, accuracy: 0.001)
        XCTAssertEqual(currentPm25, 8.7, accuracy: 0.001)

        let mappedForecast = try XCTUnwrap(response.forecast)
        XCTAssertEqual(mappedForecast.count, 1)
        let firstDay = try XCTUnwrap(mappedForecast.first)
        XCTAssertEqual(firstDay.date, "2026-04-19")
        let pm25High = try XCTUnwrap(firstDay.pm25High)
        let pm25Low = try XCTUnwrap(firstDay.pm25Low)
        let pm10High = try XCTUnwrap(firstDay.pm10High)
        let pm10Low = try XCTUnwrap(firstDay.pm10Low)
        XCTAssertEqual(pm25High, 14.0, accuracy: 0.001)
        XCTAssertEqual(pm25Low, 7.0, accuracy: 0.001)
        XCTAssertEqual(pm10High, 22.0, accuracy: 0.001)
        XCTAssertEqual(pm10Low, 11.0, accuracy: 0.001)
        XCTAssertEqual(firstDay.usAqiHigh, 90)
        XCTAssertEqual(firstDay.usAqiLow, 45)
    }

    func testAirQualityResponseMapsNilCurrent() throws {
        let generated = GetAirQualityQuery.Data.GetAirQuality(
            latitude: 40.0,
            longitude: -74.0,
            current: nil,
            forecast: nil
        )

        let response = AirQualityResponse(generated: generated)

        let latitude = try XCTUnwrap(response.latitude)
        let longitude = try XCTUnwrap(response.longitude)
        XCTAssertEqual(latitude, 40.0, accuracy: 0.0001)
        XCTAssertEqual(longitude, -74.0, accuracy: 0.0001)
        XCTAssertNil(response.current)
        XCTAssertNil(response.forecast)
    }

    func testAirQualityResponseMapsForecastWithNilOptionals() {
        let forecast = [
            GetAirQualityQuery.Data.GetAirQuality.Forecast(
                date: "2026-04-20",
                pm25High: nil,
                pm25Low: nil,
                pm10High: nil,
                pm10Low: nil,
                usAqiHigh: nil,
                usAqiLow: nil
            ),
        ]
        let generated = GetAirQualityQuery.Data.GetAirQuality(
            latitude: 0.0,
            longitude: 0.0,
            current: nil,
            forecast: forecast
        )

        let response = AirQualityResponse(generated: generated)

        XCTAssertEqual(response.forecast?.count, 1)
        XCTAssertEqual(response.forecast?.first?.date, "2026-04-20")
        XCTAssertNil(response.forecast?.first?.pm25High)
        XCTAssertNil(response.forecast?.first?.usAqiHigh)
    }
}
