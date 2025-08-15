//
//  WeatherData+CoreDataProperties.swift
//  Weather
//
//  Created by Mark Davis on 8/14/25.
//
//

import CoreData
import Foundation

public extension WeatherData {
    @nonobjc class func fetchRequest() -> NSFetchRequest<WeatherData> {
        return NSFetchRequest<WeatherData>(entityName: "WeatherData")
    }

    @NSManaged var id: UUID?
    @NSManaged var unitOfMeasurement: String?
    @NSManaged var cachedAt: Date?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var currentweather: CurrentWeather?
    @NSManaged var dailyweather: NSSet?
    @NSManaged var hourlyweather: NSSet?
}

// MARK: Generated accessors for dailyweather

public extension WeatherData {
    @objc(addDailyweatherObject:)
    @NSManaged func addToDailyweather(_ value: DailyWeather)

    @objc(removeDailyweatherObject:)
    @NSManaged func removeFromDailyweather(_ value: DailyWeather)

    @objc(addDailyweather:)
    @NSManaged func addToDailyweather(_ values: NSSet)

    @objc(removeDailyweather:)
    @NSManaged func removeFromDailyweather(_ values: NSSet)
}

// MARK: Generated accessors for hourlyweather

public extension WeatherData {
    @objc(addHourlyweatherObject:)
    @NSManaged func addToHourlyweather(_ value: HourlyWeather)

    @objc(removeHourlyweatherObject:)
    @NSManaged func removeFromHourlyweather(_ value: HourlyWeather)

    @objc(addHourlyweather:)
    @NSManaged func addToHourlyweather(_ values: NSSet)

    @objc(removeHourlyweather:)
    @NSManaged func removeFromHourlyweather(_ values: NSSet)
}

extension WeatherData: Identifiable {}
