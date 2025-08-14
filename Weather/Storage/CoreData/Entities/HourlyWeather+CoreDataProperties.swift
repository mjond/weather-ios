//
//  HourlyWeather+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import Foundation
import CoreData


extension HourlyWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourlyWeather> {
        return NSFetchRequest<HourlyWeather>(entityName: "HourlyWeather")
    }

    @NSManaged public var time: String?
    @NSManaged public var temperature: Double
    @NSManaged public var isDay: Bool
    @NSManaged public var weatherCode: Int16
    @NSManaged public var origin: WeatherData?

}

extension HourlyWeather : Identifiable {

}
