//
//  DateProvider.swift
//  Weather
//
//  Created by Mark Davis on 1/24/25.
//

import Foundation

protocol DateProviderProtocol {
    func currentDate() -> Date
}

class DateProvider: DateProviderProtocol {
    func currentDate() -> Date {
        return Date()
    }
}
