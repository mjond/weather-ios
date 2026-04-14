//
//  AirQualityService.swift
//  Weather
//
//  Created by Mark Davis on 4/13/26.
//

import Amplify
import AWSPluginsCore
import Foundation

protocol WeatherAPIClientProtocol {
    func fetchAirQuality(
        latitude: Double,
        longitude: Double,
        forecastDays: Int?
    ) async throws -> AirQualityResponse
}

final class WeatherAPIClient: WeatherAPIClientProtocol {
    func fetchAirQuality(
        latitude: Double,
        longitude: Double,
        forecastDays: Int? = nil
    ) async throws -> AirQualityResponse {
        var variables: [String: Any] = [
            "latitude": latitude,
            "longitude": longitude,
        ]
        if let forecastDays {
            variables["forecastDays"] = forecastDays
        }

        let request = GraphQLRequest<GetAirQualityQuery.Data>(
            apiName: "WeatherAPI",
            document: GetAirQualityQuery.operationString,
            variables: variables,
            responseType: GetAirQualityQuery.Data.self
        )

        let result = try await Amplify.API.query(request: request)

        switch result {
        case let .success(data):
            guard let generated = data.getAirQuality else {
                throw WeatherAPIError.noData
            }
            return AirQualityResponse(generated: generated)
        case let .failure(error):
            throw error
        }
    }
}

enum WeatherAPIError: Error {
    case graphQLErrors(String)
    case noData
}
