//
//  DailyWeather+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import Foundation
import CoreData


extension DailyWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeather> {
        return NSFetchRequest<DailyWeather>(entityName: "DailyWeather")
    }

    @NSManaged public var time: String?
    @NSManaged public var minTemperature: Double
    @NSManaged public var maxTemperature: Double
    @NSManaged public var weatherCode: Int16
    @NSManaged public var sunrise: String?
    @NSManaged public var sunset: String?
    @NSManaged public var precipitationProbabilityMean: Double
    @NSManaged public var precipitationSum: Double
    @NSManaged public var uvIndexMax: Double
    @NSManaged public var windSpeedMax: Double
    @NSManaged public var windGustsMax: Double
    @NSManaged public var windDirectionDominant: Int16
    @NSManaged public var origin: WeatherData?

}

extension DailyWeather : Identifiable {

}
