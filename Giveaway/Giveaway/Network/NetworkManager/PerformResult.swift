//
//  PerformResult.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//
import Foundation
import Moya

/// Extension for `ModelTargetType` protocol providing a convenience method to perform an asynchronous
/// network request and return the result as a `Result` type.
extension ModelTargetType {
    /// Performs an asynchronous network request and returns the result as a `Result` type.
    ///
    /// - Returns: A `Result` containing the decoded response or an error.
    func performResult() async -> Result<Response, APIError> {
        // Check if running in SwiftUI preview mode
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // Return mock response immediately
            return .success(mockResponse)
        }
        
        // Check for internet connectivity
        guard NetworkMonitor.shared.isReachable else {
            return .failure(.noNetwork)
        }

        // Create a MoyaProvider
        let provider = MoyaProvider<Self>()

        return await withCheckedContinuation { continuation in
            // Construct the URLRequest manually for logging
            let urlRequest: URLRequest
            do {
                let url = self.baseURL.appendingPathComponent(self.requestPath).absoluteString // Removed `try`
                guard let requestURL = URL(string: url) else {
                    continuation.resume(returning: .failure(.invalidURL))
                    return
                }
                
                var request = URLRequest(url: requestURL)
                request.httpMethod = self.requestMethod.rawValue
                request.allHTTPHeaderFields = self.mergedHeaders
                
                // Configure the request based on the task
                switch self.requestTask {
                case .plain:
                    break // No additional configuration needed
                case .parameters(let parameters):
                    request = try URLEncoding.default.encode(request, with: parameters)
                case .encodedBody(let encodable):
                    let encoder = JSONEncoder()
                    request.httpBody = try encoder.encode(encodable)
                }
                
                urlRequest = request
                requestLogger(request: urlRequest)
            } catch {
                continuation.resume(returning: .failure(.invalidURL))
                return
            }

            provider.request(self) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try response.map(Response.self)
                        // Log the successful response
                        responseLogger(
                            request: urlRequest,
                            responseData: response.data,
                            response: response.response // Extract HTTPURLResponse from Moya's Response
                        )
                        continuation.resume(returning: .success(decodedResponse))
                    } catch {
                        // Log the decoding error
                        responseLogger(
                            request: urlRequest,
                            response: response.response, // Extract HTTPURLResponse from Moya's Response
                            error: error
                        )
                        continuation.resume(returning: .failure(.dataConversionFailed))
                    }
                case .failure(let error):
                    // Log the network error
                    let httpResponse = error.response?.response // Extract HTTPURLResponse from Moya's Error
                    responseLogger(
                        request: urlRequest,
                        response: httpResponse, // Pass the extracted HTTPURLResponse
                        error: error
                    )
                    let statusCode = error.response?.statusCode ?? 400
                    continuation.resume(returning: .failure(.httpError(statusCode: statusCode)))
                }
            }
        }
    }
}

/// Extension for `SuccessTargetType` protocol providing a convenience method to perform an asynchronous
/// network request and return the result as a `Result` type.
extension SuccessTargetType {
    /// Performs an asynchronous network request and returns the result as a `Result` type.
    ///
    /// - Returns: A `Result` indicating success or an error.
    func performResult() async -> Result<Void, APIError> {
        // Check for internet connectivity
        guard NetworkMonitor.shared.isReachable else {
            return .failure(.noNetwork)
        }

        // Create a MoyaProvider
        let provider = MoyaProvider<Self>()

        return await withCheckedContinuation { continuation in
            // Construct the URLRequest manually for logging
            let urlRequest: URLRequest
            do {
                let url = self.baseURL.appendingPathComponent(self.requestPath).absoluteString // Removed `try`
                guard let requestURL = URL(string: url) else {
                    continuation.resume(returning: .failure(.invalidURL))
                    return
                }
                
                var request = URLRequest(url: requestURL)
                request.httpMethod = self.requestMethod.rawValue
                request.allHTTPHeaderFields = self.mergedHeaders
                
                // Configure the request based on the task
                switch self.requestTask {
                case .plain:
                    break // No additional configuration needed
                case .parameters(let parameters):
                    request = try URLEncoding.default.encode(request, with: parameters)
                case .encodedBody(let encodable):
                    let encoder = JSONEncoder()
                    request.httpBody = try encoder.encode(encodable)
                }
                
                urlRequest = request
                requestLogger(request: urlRequest)
            } catch {
                continuation.resume(returning: .failure(.invalidURL))
                return
            }

            provider.request(self) { result in
                switch result {
                case .success(let response):
                    // Log the successful response
                    responseLogger(
                        request: urlRequest,
                        responseData: response.data,
                        response: response.response // Extract HTTPURLResponse from Moya's Response
                    )
                    continuation.resume(returning: .success(()))
                case .failure(let error):
                    // Log the network error
                    let httpResponse = error.response?.response // Extract HTTPURLResponse from Moya's Error
                    responseLogger(
                        request: urlRequest,
                        response: httpResponse, // Pass the extracted HTTPURLResponse
                        error: error
                    )
                    let statusCode = error.response?.statusCode ?? 400
                    continuation.resume(returning: .failure(.httpError(statusCode: statusCode)))
                }
            }
        }
    }
}
