//
//  AirQualityServiceTests.swift
//  WeatherTests
//
//  Created by Mark Davis on 4/18/26.
//

@testable import Weather
import Amplify
import XCTest

// MARK: - Mocks for AirQualityService

/// Stand-in for `AirQualityService` in unit tests (real service requires Amplify + network).
final class MockAirQualityService: AirQualityServiceProtocol {
    enum MockError: Error {
        case simulatedFailure
    }

    private(set) var lastLatitude: Double?
    private(set) var lastLongitude: Double?
    private(set) var lastForecastDays: Int?

    var responseToReturn: AirQualityResponse?
    var errorToThrow: Error?

    func fetchAirQuality(latitude: Double, longitude: Double, forecastDays: Int?) async throws -> AirQualityResponse {
        lastLatitude = latitude
        lastLongitude = longitude
        lastForecastDays = forecastDays

        if let errorToThrow {
            throw errorToThrow
        }
        guard let responseToReturn else {
            throw AirQualityError.noData
        }
        return responseToReturn
    }
}

final class StubIAMSigningPreparation: AirQualityIAMSigningPreparing {
    private(set) var prepareCallCount = 0
    var errorToThrow: Error?

    func prepareForIAMSigning() async throws {
        prepareCallCount += 1
        if let errorToThrow {
            throw errorToThrow
        }
    }
}

final class StubGetAirQualityExecutor: AirQualityGetAirQualityExecuting {
    private(set) var executeCallCount = 0
    private(set) var lastDocument: String?
    private(set) var lastVariables: [String: Any]?
    var responseToReturn: GraphQLResponse<GetAirQualityQuery.Data>?
    var errorToThrow: Error?

    func executeGetAirQuality(
        document: String,
        variables: [String: Any]
    ) async throws -> GraphQLResponse<GetAirQualityQuery.Data> {
        executeCallCount += 1
        lastDocument = document
        lastVariables = variables
        if let errorToThrow {
            throw errorToThrow
        }
        guard let responseToReturn else {
            preconditionFailure("Set responseToReturn for this test")
        }
        return responseToReturn
    }
}

// MARK: - Tests

final class AirQualityGraphQLVariablesBuilderTests: XCTestCase {
    func testMakeVariablesUsesFloatCoordinates() throws {
        let variables = AirQualityGraphQLVariablesBuilder.makeVariables(latitude: 37.7749, longitude: -122.4194, forecastDays: nil)
        let lat = try XCTUnwrap(variables["latitude"] as? Float)
        let lon = try XCTUnwrap(variables["longitude"] as? Float)
        XCTAssertEqual(Double(lat), 37.7749, accuracy: 0.0001)
        XCTAssertEqual(Double(lon), -122.4194, accuracy: 0.0001)
        XCTAssertNil(variables["forecastDays"])
    }

    func testMakeVariablesIncludesForecastDaysWhenProvided() {
        let variables = AirQualityGraphQLVariablesBuilder.makeVariables(latitude: 0, longitude: 0, forecastDays: 7)
        XCTAssertEqual(variables["forecastDays"] as? Int, 7)
    }
}

final class AirQualityServiceTests: XCTestCase {
    func testGetAirQualityQueryOperationIncludesExpectedFields() {
        let document = GetAirQualityQuery.operationString
        XCTAssertTrue(document.contains("getAirQuality"))
        XCTAssertTrue(document.contains("latitude"))
        XCTAssertTrue(document.contains("longitude"))
        XCTAssertTrue(document.contains("usAqi"))
        XCTAssertTrue(document.contains("forecast"))
    }

    func testFetchAirQualityCallsIAMPrepareBeforeQueryAndPassesDocumentAndVariables() async throws {
        let iam = StubIAMSigningPreparation()
        let graphql = StubGetAirQualityExecutor()
        let generated = GetAirQualityQuery.Data.GetAirQuality(
            latitude: 1.0,
            longitude: 2.0,
            current: nil,
            forecast: nil
        )
        graphql.responseToReturn = .success(GetAirQualityQuery.Data(getAirQuality: generated))

        let service = AirQualityService(iamSigning: iam, queryExecutor: graphql)
        _ = try await service.fetchAirQuality(latitude: 10.5, longitude: -20.25, forecastDays: 3)

        XCTAssertEqual(iam.prepareCallCount, 1)
        XCTAssertEqual(graphql.executeCallCount, 1)
        XCTAssertEqual(graphql.lastDocument, GetAirQualityQuery.operationString)
        let vars = try XCTUnwrap(graphql.lastVariables)
        let latitudeVar = try XCTUnwrap(vars["latitude"] as? Float)
        let longitudeVar = try XCTUnwrap(vars["longitude"] as? Float)
        XCTAssertEqual(Double(latitudeVar), 10.5, accuracy: 0.0001)
        XCTAssertEqual(Double(longitudeVar), -20.25, accuracy: 0.0001)
        XCTAssertEqual(vars["forecastDays"] as? Int, 3)
    }

    func testFetchAirQualitySuccessReturnsAirQualityResponse() async throws {
        let iam = StubIAMSigningPreparation()
        let graphql = StubGetAirQualityExecutor()
        let current = GetAirQualityQuery.Data.GetAirQuality.Current(
            time: "2026-04-18T12:00",
            usAqi: 42,
            pm10: 1.0,
            pm25: 2.0
        )
        let generated = GetAirQualityQuery.Data.GetAirQuality(
            latitude: 40.0,
            longitude: -74.0,
            current: current,
            forecast: nil
        )
        graphql.responseToReturn = .success(GetAirQualityQuery.Data(getAirQuality: generated))

        let service = AirQualityService(iamSigning: iam, queryExecutor: graphql)
        let response = try await service.fetchAirQuality(latitude: 40, longitude: -74, forecastDays: nil)

        let lat = try XCTUnwrap(response.latitude)
        let lon = try XCTUnwrap(response.longitude)
        XCTAssertEqual(lat, 40.0, accuracy: 0.0001)
        XCTAssertEqual(lon, -74.0, accuracy: 0.0001)
        XCTAssertEqual(response.current?.usAqi, 42)
    }

    func testFetchAirQualityThrowsNoDataWhenPayloadMissing() async throws {
        let iam = StubIAMSigningPreparation()
        let graphql = StubGetAirQualityExecutor()
        graphql.responseToReturn = .success(GetAirQualityQuery.Data(getAirQuality: nil))

        let service = AirQualityService(iamSigning: iam, queryExecutor: graphql)

        do {
            _ = try await service.fetchAirQuality(latitude: 0, longitude: 0, forecastDays: nil)
            XCTFail("Expected AirQualityError.noData")
        } catch AirQualityError.noData {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchAirQualityPropagatesGraphQLFailure() async throws {
        let iam = StubIAMSigningPreparation()
        let graphql = StubGetAirQualityExecutor()
        graphql.responseToReturn = .failure(GraphQLResponseError<GetAirQualityQuery.Data>.error([GraphQLError(message: "upstream")]))

        let service = AirQualityService(iamSigning: iam, queryExecutor: graphql)

        do {
            _ = try await service.fetchAirQuality(latitude: 0, longitude: 0, forecastDays: nil)
            XCTFail("Expected error")
        } catch let error as GraphQLResponseError<GetAirQualityQuery.Data> {
            if case .error(let errors) = error {
                XCTAssertEqual(errors.first?.message, "upstream")
            } else {
                XCTFail("Expected .error case")
            }
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testFetchAirQualityPropagatesQueryThrow() async throws {
        let iam = StubIAMSigningPreparation()
        let graphql = StubGetAirQualityExecutor()
        struct TransportError: Error {}
        graphql.errorToThrow = TransportError()

        let service = AirQualityService(iamSigning: iam, queryExecutor: graphql)

        do {
            _ = try await service.fetchAirQuality(latitude: 0, longitude: 0, forecastDays: nil)
            XCTFail("Expected error")
        } catch is TransportError {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFetchAirQualityPropagatesIAMSigningErrorAndSkipsQuery() async throws {
        let iam = StubIAMSigningPreparation()
        struct IAMError: Error {}
        iam.errorToThrow = IAMError()

        let graphql = StubGetAirQualityExecutor()
        let generated = GetAirQualityQuery.Data.GetAirQuality(latitude: 0, longitude: 0, current: nil, forecast: nil)
        graphql.responseToReturn = .success(GetAirQualityQuery.Data(getAirQuality: generated))

        let service = AirQualityService(iamSigning: iam, queryExecutor: graphql)

        do {
            _ = try await service.fetchAirQuality(latitude: 0, longitude: 0, forecastDays: nil)
            XCTFail("Expected error")
        } catch is IAMError {
            XCTAssertEqual(iam.prepareCallCount, 1)
            XCTAssertEqual(graphql.executeCallCount, 0)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testMockAirQualityServicePassesCoordinatesAndOptionalForecastDays() async throws {
        let mock = MockAirQualityService()
        let current = GetAirQualityQuery.Data.GetAirQuality.Current(
            time: "2026-04-18T00:00",
            usAqi: 10,
            pm10: 1.0,
            pm25: 2.0
        )
        let generated = GetAirQualityQuery.Data.GetAirQuality(
            latitude: 1.0,
            longitude: 2.0,
            current: current,
            forecast: nil
        )
        mock.responseToReturn = AirQualityResponse(generated: generated)

        let result = try await mock.fetchAirQuality(latitude: 37.5, longitude: -122.5, forecastDays: 7)

        let capturedLatitude = try XCTUnwrap(mock.lastLatitude)
        let capturedLongitude = try XCTUnwrap(mock.lastLongitude)
        XCTAssertEqual(capturedLatitude, 37.5, accuracy: 0.0001)
        XCTAssertEqual(capturedLongitude, -122.5, accuracy: 0.0001)
        XCTAssertEqual(mock.lastForecastDays, 7)
        let resultLatitude = try XCTUnwrap(result.latitude)
        let resultLongitude = try XCTUnwrap(result.longitude)
        XCTAssertEqual(resultLatitude, 1.0, accuracy: 0.0001)
        XCTAssertEqual(resultLongitude, 2.0, accuracy: 0.0001)
        XCTAssertEqual(result.current?.usAqi, 10)
    }

    func testMockAirQualityServiceOmitsForecastDaysWhenNil() async throws {
        let mock = MockAirQualityService()
        let generated = GetAirQualityQuery.Data.GetAirQuality(
            latitude: 0.0,
            longitude: 0.0,
            current: nil,
            forecast: nil
        )
        mock.responseToReturn = AirQualityResponse(generated: generated)

        _ = try await mock.fetchAirQuality(latitude: 10.0, longitude: 20.0, forecastDays: nil)

        XCTAssertNil(mock.lastForecastDays)
    }

    func testMockAirQualityServiceThrowsConfiguredError() async throws {
        let mock = MockAirQualityService()
        mock.errorToThrow = MockAirQualityService.MockError.simulatedFailure

        do {
            _ = try await mock.fetchAirQuality(latitude: 0, longitude: 0, forecastDays: nil)
            XCTFail("Expected error to be thrown")
        } catch MockAirQualityService.MockError.simulatedFailure {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testMockAirQualityServiceThrowsNoDataWhenNoResponseConfigured() async throws {
        let mock = MockAirQualityService()
        mock.responseToReturn = nil
        mock.errorToThrow = nil

        do {
            _ = try await mock.fetchAirQuality(latitude: 0, longitude: 0, forecastDays: nil)
            XCTFail("Expected AirQualityError.noData")
        } catch AirQualityError.noData {
            // expected
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
