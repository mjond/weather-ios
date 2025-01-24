//
//  Untitled.swift
//  Weather
//
//  Created by Mark Davis on 1/24/25.
//

@testable import Weather
import Foundation

class MockDateProvider: DateProviderProtocol {
    var fixedDate: Date

    init(fixedDate: Date) {
        self.fixedDate = fixedDate
    }

    func currentDate() -> Date {
        return fixedDate
    }
}
