//
//  WeatherValueFormatter.swift
//  Weather
//
//  Created by Mark Davis on 4/21/26.
//

import Foundation

enum WeatherValueFormatter {
    static func formatPrecipitation(precipitationAmount: Double, unit: UnitOfMeasurement) -> String {
        if unit == .imperial {
            let precipitationInches = precipitationAmount * 0.0393701

            if precipitationInches == 0 {
                return "0 inches"
            } else if precipitationInches < 0.6 {
                return "<1 inch"
            }

            let precipitationRounded = precipitationInches.rounded()
            let precipitationAsString = String(format: "%.0f", precipitationRounded)
            if precipitationRounded == 1.0 {
                return precipitationAsString + " inch"
            }
            return precipitationAsString + " inches"
        }

        let precipitationAsString = String(format: "%.0f", precipitationAmount)
        return precipitationAsString + " mm"
    }

    static func formatWind(from amount: Double, unit: UnitOfMeasurement) -> String {
        if unit == .imperial {
            let amountAsImperial = amount * 0.6214
            return String(format: "%.0f", amountAsImperial) + " mph"
        }

        return String(format: "%.0f", amount) + " km/h"
    }
}
