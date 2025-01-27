//
//  TargetRequest.swift
//  Giveaway
//
//  Created by Bakr mohamed on 25/01/2025.
//
import Foundation
import Moya

/// Protocol defining the properties required for a target network request.
///
/// A `TargetRequest` specifies the essential components of a network request,
/// including the base URL, request path, HTTP method, request task, and headers.
protocol TargetRequest: TargetType {
    /// The base URL for the network request.
    var baseURL: String { get }
    
    /// The specific path to be appended to the base URL for the request.
    var requestPath: String { get }
    
    /// The HTTP method to be used for the request (e.g., GET, POST, PUT).
    var requestMethod: Moya.Method { get }
    
    /// The type of task to be performed as part of the network request (e.g., plain request, download, upload).
    var requestTask: RequestTask { get }
    
    /// The headers to be included in the request.
    var additionalheaders: [String: String] { get }
}

/// Default implementation of `TargetRequest` protocol, providing a plain request task by default.
extension TargetRequest {
    /// Default headers to be Empty
    var additionalheaders: [String: String] {
        return [:]
    }
    
    /// Default headers for the request.
    var defaultHeaders: [String: String] {
        var headers: [String: String] = [:]
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "*/*"
        return headers
    }
    
    /// Merges the default headers with the provided headers.
    /// If a header with the same key exists in both, the provided header takes precedence.
    /// - Returns: Merged headers.
    var mergedHeaders: [String: String] {
        return defaultHeaders.merging(additionalheaders) { (_, new) in new }
    }
    
    /// Use this to check about internet connection
    static var isConnectedToInternet: Bool {
        return NetworkMonitor.shared.isReachable
    }
}

/// Conformance to Moya's `TargetType`
extension TargetRequest {
    /// The base URL for the network request.
    var baseURL: URL {
        return URL(string: self.baseURL)!
    }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String {
        return self.requestPath
    }
    
    /// The HTTP method used in the request.
    var method: Moya.Method {
        return self.requestMethod
    }
    
    /// The type of HTTP task to be performed.
    var task: Task {
        switch self.requestTask {
        case .plain:
            return .requestPlain
        case .parameters(let parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .encodedBody(let encodable):
            return .requestJSONEncodable(encodable)
        }
    }
    
    /// The headers to be used in the request.
    var headers: [String: String]? {
        return self.mergedHeaders
    }
    
    /// Provides stub data for use in testing. Default is `Data()`.
    var sampleData: Data {
        return Data()
    }
    
    /// The type of validation to perform on the request. Default is `.none`.
    var validationType: ValidationType {
        return .none
    }
}

/// Protocol for a successful network request.
/// `SuccessTargetType` is a marker protocol indicating that a network request is expected to be successful.
protocol SuccessTargetType: TargetRequest { }

/// Protocol for a network request that expects a Codable response model.
/// `ModelTargetType` is a specialized protocol for network requests that are expected to
/// receive a response in the form of a Codable model conforming to the associated `Response` type.
protocol ModelTargetType: TargetRequest {
    /// The Codable response type expected from the network request.
    associatedtype Response: Codable
    var mockResponse: Response { get }
}
