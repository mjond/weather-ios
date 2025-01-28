//
//  DirectionHelperTests.swift
//  WeatherTests
//
//  Created by Mark Davis on 1/28/25.
//

@testable import Weather
import XCTest

final class DirectionHelperTests: XCTestCase {
    func testGetDirection() {
        XCTAssertEqual(DirectionHelper.getDirection(from: 0.0), "N")
        XCTAssertEqual(DirectionHelper.getDirection(from: 22.5), "NNE")
        XCTAssertEqual(DirectionHelper.getDirection(from: 45.0), "NE")
        XCTAssertEqual(DirectionHelper.getDirection(from: 67.5), "ENE")
        XCTAssertEqual(DirectionHelper.getDirection(from: 90.0), "E")
        XCTAssertEqual(DirectionHelper.getDirection(from: 135.0), "SE")
        XCTAssertEqual(DirectionHelper.getDirection(from: 180.0), "S")
        XCTAssertEqual(DirectionHelper.getDirection(from: 225.0), "SW")
        XCTAssertEqual(DirectionHelper.getDirection(from: 270.0), "W")
        XCTAssertEqual(DirectionHelper.getDirection(from: 315.0), "NW")
        XCTAssertEqual(DirectionHelper.getDirection(from: 360.0), "N")
    }

    func testGetDirectionWithDegrees() {
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 0.0), " 0° N")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 22.5), " 22° NNE")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 45.0), " 45° NE")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 67.5), " 68° ENE")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 90.0), " 90° E")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 135.0), " 135° SE")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 180.0), " 180° S")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 225.0), " 225° SW")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 270.0), " 270° W")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 315.0), " 315° NW")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 360.0), " 360° N")
    }

    func testEdgeCases() {
        XCTAssertEqual(DirectionHelper.getDirection(from: 11.24), "N") // Just below NNE
        XCTAssertEqual(DirectionHelper.getDirection(from: 11.25), "NNE") // Boundary case
        XCTAssertEqual(DirectionHelper.getDirection(from: 348.74), "NNW") // Just below N
        XCTAssertEqual(DirectionHelper.getDirection(from: 348.75), "N") // Boundary case

        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 11.24), " 11° N") // Just below NNE
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 11.25), " 11° NNE") // Boundary case
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 348.74), " 349° NNW") // Just below N
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 348.75), " 349° N") // Boundary case
    }

    func testOutOfBounds() {
        XCTAssertEqual(DirectionHelper.getDirection(from: -10.0), "N") // Handles negative degrees
        XCTAssertEqual(DirectionHelper.getDirection(from: 370.0), "N") // Wraps correctly for >360

        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: -10.0), " -10° N")
        XCTAssertEqual(DirectionHelper.getDirectionWithDegrees(from: 370.0), " 370° N")
    }
}
