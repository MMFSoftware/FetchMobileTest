@testable import FetchMobileTest
import Foundation
import Testing

struct GenericEndpointTests {
    @Test func testEndpointInitialization() {
        let urlString = "https://api.example.com/data"
        let method: HTTPMethod = .post
        let queryParams = [
            URLQueryItem(name: "key", value: "value"),
            URLQueryItem(name: "anotherKey", value: "anotherValue")
        ]

        let endpoint = GenericEndpoint(url: urlString, method: method, queryParams: queryParams)

        #expect(endpoint.url == urlString)
        #expect(endpoint.method == method)
        #expect(endpoint.queryParams?.count == queryParams.count)
        #expect(endpoint.queryParams?.first?.name == "anotherKey", "QueryParams should be sorted by name")
        #expect(endpoint.queryParams?.last?.name == "key", "QueryParams should be sorted by name")
    }

    @Test func testEndpointURLConstructionWithQueryParams() {
        let baseURL = "https://api.example.com/data"
        let queryParams = [
            URLQueryItem(name: "search", value: "query"),
            URLQueryItem(name: "page", value: "1")
        ]

        let endpoint = GenericEndpoint(url: baseURL, queryParams: queryParams)
        let expectedURLString = "\(baseURL)?page=1&search=query"

        var urlComponents = URLComponents(string: endpoint.url)
        urlComponents?.queryItems = endpoint.queryParams

        #expect(urlComponents?.url?.absoluteString == expectedURLString)
    }
}
