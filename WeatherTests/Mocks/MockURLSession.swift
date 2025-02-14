//
//  MockURLSession.swift
//  Weather
//
//  Created by Mark Davis on 1/21/25.
//

@testable import Weather
import Foundation

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var error: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = error {
            throw error
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        return (data ?? Data(), response)
    }
}
