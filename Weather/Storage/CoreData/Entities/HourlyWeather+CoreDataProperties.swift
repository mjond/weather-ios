//
//  HourlyWeather+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import CoreData
import Foundation

public extension HourlyWeather {
    @nonobjc class func fetchRequest() -> NSFetchRequest<HourlyWeather> {
        return NSFetchRequest<HourlyWeather>(entityName: "HourlyWeather")
    }

    @NSManaged var time: String?
    @NSManaged var temperature: Double
    @NSManaged var isDay: Bool
    @NSManaged var weatherCode: Int16
    @NSManaged var origin: WeatherData?
}

extension HourlyWeather: Identifiable {}
