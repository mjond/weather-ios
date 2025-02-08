//
//  SettingsViewModel.swift
//  Weather
//
//  Created by Mark Davis on 11/4/24.
//

import SwiftUI

final class SettingsViewModel: ObservableObject {
    @Published var isImperialActive: Bool
    @Published var isMetricActive: Bool
    
    private var settings: WeatherSettingsProtocol

    init(settings: any WeatherSettingsProtocol = WeatherSettings.shared) {
        self.settings = settings
        
        // Initialize state based on stored settings
        if settings.unitOfMeasurement == .imperial {
            isImperialActive = true
            isMetricActive = false
        } else {
            isImperialActive = false
            isMetricActive = true
        }
    }

    func selectImperial() {
        guard settings.unitOfMeasurement != .imperial else { return }
        settings.unitOfMeasurement = .imperial
        isImperialActive = true
        isMetricActive = false
    }

    func selectMetric() {
        guard settings.unitOfMeasurement != .metric else { return }
        settings.unitOfMeasurement = .metric
        isImperialActive = false
        isMetricActive = true
    }
}
