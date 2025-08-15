//
//  HomeViewModelTests.swift
//  WeatherTests
//
//  Created by Mark Davis on 1/4/25.
//

import CoreLocation
@testable import Weather
import XCTest

final class HomeViewModelTests: XCTestCase {
    var mockWeatherService: MockWeatherService!
    var mockSettings: MockWeatherSettings!
    var mockDateProvider: MockDateProvider!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockSettings = MockWeatherSettings()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        if let fixedDate = dateFormatter.date(from: "2025-01-15T05:23") {
            mockDateProvider = MockDateProvider(fixedDate: fixedDate)
            viewModel = HomeViewModel(settings: mockSettings, weatherService: mockWeatherService, dateProvider: mockDateProvider)
        }
    }

    override func tearDown() {
        mockWeatherService = nil
        mockSettings = nil
        viewModel = nil
        super.tearDown()
    }

    func testHomeViewModelSuccess() async {
        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)

        await viewModel.getWeather(location: location)

        sleep(1)

        if case let .success(homeModel) = viewModel.state {
            print(homeModel)
            XCTAssertEqual(homeModel.currentTemperature, "24")
            XCTAssertEqual(homeModel.currentWeatherCode, 1)
            XCTAssertEqual(homeModel.apparentTemperature, "25")
        } else {
            XCTFail("Expected state to be success, but was \(viewModel.state)")
        }
    }

//    func testLoadingState() async {
//        let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
//        mockWeatherService.mockWeatherData = nil
//
//        await viewModel.getWeather(location: mockLocation)
//
//        XCTAssertEqual(viewModel.state, .loading)
//    }

//    func testFailureState() async {
//        let mockLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
//        mockWeatherService.shouldReturnError = true
//
//        await viewModel.getWeather(location: mockLocation)
//
//        XCTAssertEqual(viewModel.state, .failure)
//    }
}
