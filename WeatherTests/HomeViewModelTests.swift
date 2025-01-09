//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Mark Davis on 1/4/25.
//

@testable import Weather
import XCTest

final class HomeViewModelTests: XCTestCase {
    var mockWeatherService: MockWeatherService!
    var mockSettings: MockWeatherSettings!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockSettings = MockWeatherSettings()
        viewModel = HomeViewModel(settings: mockSettings, weatherService: mockWeatherService)
    }

    override func tearDown() {
        mockWeatherService = nil
        mockSettings = nil
        viewModel = nil
        super.tearDown()
    }

    func testExample() async {
        // make a mock HomeModel with the mockWeatherData
//        let data = mockWeatherService.mockWeatherData
//        let location = CLLocation(latitude: 37.7749, longitude: -122.4194)
//
//        await viewModel.getWeather(location: location)
//        XCTAssertEqual(viewModel.state, .success(data))
    }
}
