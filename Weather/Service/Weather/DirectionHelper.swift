//
//  DirectionHelper.swift
//  Weather
//
//  Created by Mark Davis on 1/28/25.
//

class DirectionHelper {
    static func getDirection(from degrees: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                          "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]

        let index = Int((degrees + 11.25) / 22.5) % 16
        return directions[index]
    }

    static func getDirectionWithDegrees(from degrees: Double) -> String {
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                          "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]

        let index = Int((degrees + 11.25) / 22.5) % 16
        let direction = directions[index]

        let degreesAsString = String(format: "%.0f", degrees)
        let degreesWithDirection = " \(degreesAsString)° \(direction)"
        return degreesWithDirection
    }
}
