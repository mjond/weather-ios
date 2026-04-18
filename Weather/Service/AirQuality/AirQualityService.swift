//
//  AirQualityService.swift
//  Weather
//
//  Created by Mark Davis on 4/13/26.
//

import Amplify
import AWSPluginsCore
import Foundation

protocol AirQualityServiceProtocol {
    func fetchAirQuality(
        latitude: Double,
        longitude: Double,
        forecastDays: Int?
    ) async throws -> AirQualityResponse
}

// MARK: - GraphQL variables

enum AirQualityGraphQLVariablesBuilder {
    static func makeVariables(latitude: Double, longitude: Double, forecastDays: Int?) -> [String: Any] {
        var variables: [String: Any] = [
            "latitude": Float(latitude),
            "longitude": Float(longitude),
        ]
        if let forecastDays {
            variables["forecastDays"] = forecastDays
        }
        return variables
    }
}

// MARK: - Dependencies

protocol AirQualityIAMSigningPreparing {
    func prepareForIAMSigning() async throws
}

protocol AirQualityGetAirQualityExecuting {
    func executeGetAirQuality(
        document: String,
        variables: [String: Any]
    ) async throws -> GraphQLResponse<GetAirQualityQuery.Data>
}

private final class AmplifyIAMSigningPreparation: AirQualityIAMSigningPreparing {
    func prepareForIAMSigning() async throws {
        let session: AuthSession
        do {
            session = try await Amplify.Auth.fetchAuthSession()
        } catch {
            print("AirQualityService.fetchAirQuality() -> failed to fetch auth session with error: \(error)")
            throw error
        }

        guard let provider = session as? AuthAWSCredentialsProvider else {
            print(
                "AirQualityService.fetchAirQuality() -> auth session does not supply AWS credentials; " +
                    "check amplifyconfiguration.json"
            )
            throw AirQualityError.missingGuestCredentials
        }

        switch provider.getAWSCredentials() {
        case .success:
            return
        case let .failure(error):
            print(
                "AirQualityService.fetchAirQuality() -> failed to obtain AWS credentials for IAM signing " +
                    "with error: \(error)"
            )
            throw error
        }
    }
}

private final class AmplifyGetAirQualityExecutor: AirQualityGetAirQualityExecuting {
    func executeGetAirQuality(
        document: String,
        variables: [String: Any]
    ) async throws -> GraphQLResponse<GetAirQualityQuery.Data> {
        let request = GraphQLRequest<GetAirQualityQuery.Data>(
            apiName: "WeatherAPI",
            document: document,
            variables: variables,
            responseType: GetAirQualityQuery.Data.self,
            authMode: AWSAuthorizationType.awsIAM
        )
        return try await Amplify.API.query(request: request)
    }
}

// MARK: - Service

final class AirQualityService: AirQualityServiceProtocol {
    private let iamSigning: AirQualityIAMSigningPreparing
    private let queryExecutor: AirQualityGetAirQualityExecuting

    init(
        iamSigning: AirQualityIAMSigningPreparing = AmplifyIAMSigningPreparation(),
        queryExecutor: AirQualityGetAirQualityExecuting = AmplifyGetAirQualityExecutor()
    ) {
        self.iamSigning = iamSigning
        self.queryExecutor = queryExecutor
    }

    func fetchAirQuality(
        latitude: Double,
        longitude: Double,
        forecastDays: Int? = nil
    ) async throws -> AirQualityResponse {
        let variables = AirQualityGraphQLVariablesBuilder.makeVariables(
            latitude: latitude,
            longitude: longitude,
            forecastDays: forecastDays
        )

        try await iamSigning.prepareForIAMSigning()

        let result: GraphQLResponse<GetAirQualityQuery.Data>
        do {
            result = try await queryExecutor.executeGetAirQuality(
                document: GetAirQualityQuery.operationString,
                variables: variables
            )
        } catch {
            print("AirQualityService.fetchAirQuality() -> failed to fetch air quality data with error: \(error)")
            throw error
        }

        switch result {
        case let .success(data):
            guard let generated = data.getAirQuality else {
                throw AirQualityError.noData
            }
            return AirQualityResponse(generated: generated)
        case let .failure(error):
            print("AirQualityService.fetchAirQuality() -> failed to fetch air quality data with error: \(error)")
            throw error
        }
    }
}

enum AirQualityError: Error {
    case graphQLErrors(String)
    case noData
    case missingGuestCredentials
}
