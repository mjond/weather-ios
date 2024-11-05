//
//  SettingsModel.swift
//  Weather
//
//  Created by Mark Davis on 11/4/24.
//

import SwiftUI

final class WeatherSettings: ObservableObject {
    @Published var unitOfMeasurement: UnitOfMeasurement = .imperial
//    @Published var unitOfMeasurement: UnitOfMeasurement {
//        didSet {
//            updatePreference(value: unitOfMeasurement, key: UserDefaultsConstants.unitOfMeasurementSetting.rawValue)
//        }
//    }
//
//    init() {
//        if let storedUnits = UserDefaults().value(forKey: UserDefaultsConstants.unitOfMeasurementSetting.rawValue) as? String {
//            if storedUnits == UnitOfMeasurement.imperial.rawValue {
//                unitOfMeasurement = .imperial
//            } else {
//                unitOfMeasurement = .metric
//            }
//        }
//        // if there isn't a stored setting, then default to imperial
//        unitOfMeasurement = .imperial
//    }
//    
//    func updatePreference(value: UnitOfMeasurement, key: String) {
//        UserDefaults().set(value.rawValue, forKey: key)
//    }
}

enum UnitOfMeasurement: String {
    case metric
    case imperial
}
