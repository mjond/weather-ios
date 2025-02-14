//
//  WeatherSettingsMock.swift
//  Weather
//
//  Created by Mark Davis on 1/9/25.
//

@testable import Weather
import SwiftUI

final class MockWeatherSettings: WeatherSettingsProtocol {
    @Published var unitOfMeasurement: UnitOfMeasurement = .imperial

    func updatePreference(value: UnitOfMeasurement, key: String) {
        print("Mock updatePreference called with value: \(value) and key: \(key)")
    }
}
