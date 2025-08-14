//
//  WeatherData+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import Foundation
import CoreData


extension WeatherData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var unitOfMeasurement: String?
    @NSManaged public var cachedAt: Date?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var currentweather: CurrentWeather?
    @NSManaged public var dailyweather: NSSet?
    @NSManaged public var hourlyweather: NSSet?

}

// MARK: Generated accessors for dailyweather
extension WeatherData {

    @objc(addDailyweatherObject:)
    @NSManaged public func addToDailyweather(_ value: DailyWeather)

    @objc(removeDailyweatherObject:)
    @NSManaged public func removeFromDailyweather(_ value: DailyWeather)

    @objc(addDailyweather:)
    @NSManaged public func addToDailyweather(_ values: NSSet)

    @objc(removeDailyweather:)
    @NSManaged public func removeFromDailyweather(_ values: NSSet)

}

// MARK: Generated accessors for hourlyweather
extension WeatherData {

    @objc(addHourlyweatherObject:)
    @NSManaged public func addToHourlyweather(_ value: HourlyWeather)

    @objc(removeHourlyweatherObject:)
    @NSManaged public func removeFromHourlyweather(_ value: HourlyWeather)

    @objc(addHourlyweather:)
    @NSManaged public func addToHourlyweather(_ values: NSSet)

    @objc(removeHourlyweather:)
    @NSManaged public func removeFromHourlyweather(_ values: NSSet)

}

extension WeatherData : Identifiable {

}
