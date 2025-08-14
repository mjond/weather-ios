//
//  CurrentWeather+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import Foundation
import CoreData


extension CurrentWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
    }

    @NSManaged public var time: String?
    @NSManaged public var temperature: Double
    @NSManaged public var apparentTemperature: Double
    @NSManaged public var weatherCode: Int16
    @NSManaged public var origin: WeatherData?

}

extension CurrentWeather : Identifiable {

}
