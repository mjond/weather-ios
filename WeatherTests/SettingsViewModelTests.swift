//
//  SettingsViewModelTests.swift
//  Weather
//
//  Created by Mark Davis on 2/8/25.
//

import Combine
@testable import Weather
import XCTest

final class SettingsViewModelTests: XCTestCase {
    var viewModel: SettingsViewModel!
    var mockSettings: WeatherSettingsProtocol!

    override func setUp() {
        super.setUp()
        mockSettings = MockWeatherSettings()
        viewModel = SettingsViewModel(settings: mockSettings)
    }

    override func tearDown() {
        viewModel = nil
        mockSettings = nil
        super.tearDown()
    }

    func testInitialState_WhenImperial_ShouldSetImperialActive() {
        mockSettings.unitOfMeasurement = .imperial
        viewModel = SettingsViewModel(settings: mockSettings)

        XCTAssertTrue(viewModel.isImperialActive)
        XCTAssertFalse(viewModel.isMetricActive)
    }

    func testInitialState_WhenMetric_ShouldSetMetricActive() {
        mockSettings.unitOfMeasurement = .metric
        viewModel = SettingsViewModel(settings: mockSettings)

        XCTAssertFalse(viewModel.isImperialActive)
        XCTAssertTrue(viewModel.isMetricActive)
    }

    func testSelectingImperial_ShouldUpdateUnitOfMeasurement() {
        mockSettings.unitOfMeasurement = .metric
        viewModel.selectImperial()

        XCTAssertEqual(mockSettings.unitOfMeasurement, .imperial)
        XCTAssertTrue(viewModel.isImperialActive)
        XCTAssertFalse(viewModel.isMetricActive)
    }

    func testSelectingMetric_ShouldUpdateUnitOfMeasurement() {
        mockSettings.unitOfMeasurement = .imperial
        viewModel.selectMetric()

        XCTAssertEqual(mockSettings.unitOfMeasurement, .metric)
        XCTAssertFalse(viewModel.isImperialActive)
        XCTAssertTrue(viewModel.isMetricActive)
    }
}
