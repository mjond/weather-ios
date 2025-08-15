//
//  DailyWeather+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import CoreData
import Foundation

public extension DailyWeather {
    @nonobjc class func fetchRequest() -> NSFetchRequest<DailyWeather> {
        return NSFetchRequest<DailyWeather>(entityName: "DailyWeather")
    }

    @NSManaged var time: String?
    @NSManaged var minTemperature: Double
    @NSManaged var maxTemperature: Double
    @NSManaged var weatherCode: Int16
    @NSManaged var sunrise: String?
    @NSManaged var sunset: String?
    @NSManaged var precipitationProbabilityMean: Double
    @NSManaged var precipitationSum: Double
    @NSManaged var uvIndexMax: Double
    @NSManaged var windSpeedMax: Double
    @NSManaged var windGustsMax: Double
    @NSManaged var windDirectionDominant: Int16
    @NSManaged var origin: WeatherData?
}

extension DailyWeather: Identifiable {}
