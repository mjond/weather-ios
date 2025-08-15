//
//  CurrentWeather+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import CoreData
import Foundation

public extension CurrentWeather {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
    }

    @NSManaged var time: String?
    @NSManaged var temperature: Double
    @NSManaged var apparentTemperature: Double
    @NSManaged var weatherCode: Int16
    @NSManaged var origin: WeatherData?
}

extension CurrentWeather: Identifiable {}
