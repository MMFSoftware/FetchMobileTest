import Foundation

/// A protocol to abstract URLSession functionalities for testing
public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

/// Extend the actual URLSession to conform to our protocol
extension URLSession: URLSessionProtocol {}
