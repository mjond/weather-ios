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

final class AirQualityService: AirQualityServiceProtocol {
    func fetchAirQuality(
        latitude: Double,
        longitude: Double,
        forecastDays: Int? = nil
    ) async throws -> AirQualityResponse {
        var variables: [String: Any] = [
            "latitude": Float(latitude),
            "longitude": Float(longitude),
        ]
        if let forecastDays {
            variables["forecastDays"] = forecastDays
        }

        let request = GraphQLRequest<GetAirQualityQuery.Data>(
            apiName: "WeatherAPI",
            document: GetAirQualityQuery.operationString,
            variables: variables,
            responseType: GetAirQualityQuery.Data.self,
            authMode: AWSAuthorizationType.awsIAM
        )

        try await ensureGuestCredentialsForIAMSigning()

        let result: GraphQLResponse<GetAirQualityQuery.Data>
        do {
            result = try await Amplify.API.query(request: request)
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

    private func ensureGuestCredentialsForIAMSigning() async throws {
        let session: AuthSession
        do {
            session = try await Amplify.Auth.fetchAuthSession()
        } catch {
            print("AirQualityService.fetchAirQuality() -> failed to fetch auth session with error: \(error)")
            throw error
        }

        guard let provider = session as? AuthAWSCredentialsProvider else {
            print("AirQualityService.fetchAirQuality() -> auth session does not supply AWS credentials; check awsCognitoAuthPlugin CredentialsProvider.CognitoIdentity in amplifyconfiguration.json")
            throw AirQualityError.missingGuestCredentials
        }

        switch provider.getAWSCredentials() {
        case .success:
            return
        case let .failure(error):
            print("AirQualityService.fetchAirQuality() -> failed to obtain AWS credentials for IAM signing with error: \(error)")
            throw error
        }
    }
}

enum AirQualityError: Error {
    case graphQLErrors(String)
    case noData
    case missingGuestCredentials
}
