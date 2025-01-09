//
//  SettingsModel.swift
//  Weather
//
//  Created by Mark Davis on 11/4/24.
//

import SwiftUI

protocol WeatherSettingsProtocol {
    var unitOfMeasurement: UnitOfMeasurement { get set }
    func updatePreference(value: UnitOfMeasurement, key: String)
}

final class WeatherSettings: WeatherSettingsProtocol {
    static let shared = WeatherSettings()

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
