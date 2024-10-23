@testable import FetchMobileTest
import Foundation
import Testing

struct EndpointTests {
    @Test func testURLConstruction() {
        let endpoint = MockEndpoint()
        let url = endpoint.url()
        #expect(url?.absoluteString == "https://api.example.com/endpoint")
    }

    @Test func testURLRequestConstruction() {
        let endpoint = MockEndpoint()
        let request = endpoint.asURLRequest()
        #expect(request?.url?.absoluteString == "https://api.example.com/endpoint")
        #expect(request?.httpMethod == "GET")
    }

    @Test func testQueryParameters() {
        let endpoint = MockQueryEndpoint()
        let request = endpoint.asURLRequest()
        #expect(request?.url?.absoluteString.contains("query=test") ?? false)
    }

    @Test func testHeaders() {
        let endpoint = MockHeaderEndpoint()
        let request = endpoint.asURLRequest()
        #expect(request?.value(forHTTPHeaderField: "Content-Type") == "application/json")
    }

    @Test func testBody() throws {
        let endpoint = MockBodyEndpoint()
        let request = endpoint.asURLRequest()
        let bodyData = try #require(request?.httpBody)
        let bodyDictionary = try? JSONSerialization.jsonObject(with: bodyData, options: []) as? [String: String]
        #expect(bodyDictionary?["key"] == "value")
    }
}

// MARK: - Mock Endpoints
extension EndpointTests {
    struct MockEndpoint: Endpoint {
        var baseUrl: String { "https://api.example.com" }
        var path: String { "/endpoint" }
        var method: HTTPMethod { .get }
    }

    struct MockQueryEndpoint: Endpoint {
        var baseUrl: String { "https://api.example.com" }
        var path: String { "/endpoint" }
        var method: HTTPMethod { .get }
        var queryParams: [URLQueryItem]? { [URLQueryItem(name: "query", value: "test")] }
    }

    struct MockHeaderEndpoint: Endpoint {
        var baseUrl: String { "https://api.example.com" }
        var path: String { "/endpoint" }
        var method: HTTPMethod { .get }
        var headers: [String: String]? { ["Content-Type": "application/json"] }
    }

    struct MockBodyEndpoint: Endpoint {
        var baseUrl: String { "https://api.example.com" }
        var path: String { "/endpoint" }
        var method: HTTPMethod { .post }
        var body: [String: Any]? { ["key": "value"] }
    }
}
