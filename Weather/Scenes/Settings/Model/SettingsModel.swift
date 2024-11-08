//
//  SettingsModel.swift
//  Weather
//
//  Created by Mark Davis on 11/4/24.
//

import SwiftUI

final class WeatherSettings: ObservableObject {
    @Published var unitOfMeasurement: UnitOfMeasurement {
        didSet {
            updatePreference(value: unitOfMeasurement, key: UserDefaultsConstants.unitOfMeasurementSetting.rawValue)
            print("Set unit of measurement to: \(unitOfMeasurement)")
        }
    }

    init() {
        if let storedUnits = UserDefaults().value(forKey: UserDefaultsConstants.unitOfMeasurementSetting.rawValue) as? String {
            if storedUnits == UnitOfMeasurement.imperial.rawValue {
                unitOfMeasurement = .imperial
            } else {
                unitOfMeasurement = .metric
            }
        } else {
            // if there isn't a stored setting, then default to imperial
            unitOfMeasurement = .imperial            
        }
    }
    
    func updatePreference(value: UnitOfMeasurement, key: String) {
        UserDefaults().set(value.rawValue, forKey: key)
    }
}

enum UnitOfMeasurement: String {
    case metric
    case imperial
}

enum Appearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { self.rawValue }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil // Follow system
        case .light: return .light
        case .dark: return .dark
        }
    }
}
