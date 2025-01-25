//
//  AppEnums.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//

enum AppEnvironment {
    case development
    case testing
    case staging
    case release
}

/// Enum representing the types of network requests supported.
enum RequestTask {
    /// A request with no additional data in the body.
    case plain
    /// A request with URL-encoded parameters in the query string.
    case parameters(_ parameters: [String: Any])
    /// A request with a body encoded as JSON from an `Encodable` type.
    case encodedBody(Encodable)
}

/// Enum representing the types of errors that can occur in the network layer.
enum APIError: Error, Equatable {
    /// Error indicating invalid URL formation.
    case invalidURL
    /// Error indicating failure in data conversion.
    case dataConversionFailed
    /// Error indicating failure in string conversion.
    case stringConversionFailed
    /// Error representing an HTTP error with a specific status code.
    case httpError(statusCode: Int)
    /// No Internet connection.
    case noNetwork
    /// Invalid Response.
    case invalidResponse
}
