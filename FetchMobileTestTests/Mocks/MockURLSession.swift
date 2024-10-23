@testable import FetchMobileTest
import Foundation

/// Mock URLSession to return predefined data and response
class MockURLSession: URLSessionProtocol {
    var mockedData: Data?
    var mockedResponse: URLResponse?
    var mockedError: Error?

    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        if let error = mockedError {
            throw error
        }
        guard let url = request.url else {
            throw URLError(.badURL)
        }

        return (
            mockedData ?? Data(),
            mockedResponse ?? URLResponse(
                url: url,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )
        )
    }
}
