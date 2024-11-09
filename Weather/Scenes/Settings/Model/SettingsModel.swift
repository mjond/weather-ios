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
    @Published var appearance: Appearance {
        didSet {
            updatePreference(value: appearance, key: UserDefaultsConstants.appearance.rawValue)
            print("Set appearance to: \(appearance)")
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
        
        if let storedAppearance = UserDefaults().value(forKey: UserDefaultsConstants.appearance.rawValue) as? String {
            if storedAppearance == Appearance.system.rawValue {
                appearance = .system
            } else if storedAppearance == Appearance.light.rawValue {
                appearance = .light
            } else {
                appearance = .dark
            }
        } else {
            // if there isn't a stored setting, then default to system appearance settings
            appearance = .system
        }
    }
    
    func updatePreference(value: UnitOfMeasurement, key: String) {
        UserDefaults().set(value.rawValue, forKey: key)
    }
    
    func updatePreference(value: Appearance, key: String) {
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
