//
//  SettingsModel.swift
//  Weather
//
//  Created by Mark Davis on 11/4/24.
//

import SwiftUI

final class WeatherSettings: ObservableObject {
    @Published var unitOfMeasurement: UnitOfMeasurement = .imperial
    // expand this to store the selection in UserDefaults,
    // so that the setting doesn't reset on each app launch
}

enum UnitOfMeasurement: String {
    case metric
    case imperial
}
