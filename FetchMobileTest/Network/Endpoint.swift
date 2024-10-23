import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

public protocol Endpoint {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParams: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
    var timeOut: TimeInterval { get }

    func url() -> URL?
    func asURLRequest() -> URLRequest?
}

public extension Endpoint {
    var headers: [String: String]? { nil }
    var queryParams: [URLQueryItem]? { nil }
    var body: [String: Any]? { nil }
    var timeOut: TimeInterval { 30 }

    func url() -> URL? {
        let urlString = baseUrl + path
        return URL(string: urlString)
    }

    func asURLRequest() -> URLRequest? {
        guard let url = url() else { return nil }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let queryParams {
            if var queryItems = urlComponents?.queryItems {
                queryItems.append(contentsOf: queryParams)
                urlComponents?.queryItems = queryItems
            } else {
                urlComponents?.queryItems = queryParams
            }
        }

        var urlRequest: URLRequest
        if let queryItems = urlComponents?.queryItems, !queryItems.isEmpty {
            urlRequest = URLRequest(url: urlComponents?.url ?? url)
        } else {
            urlRequest = URLRequest(url: url)
        }

        if let body, !body.isEmpty {
            let httpBodyParameters = try? JSONSerialization.data(withJSONObject: body, options: [])
            urlRequest.httpBody = httpBodyParameters
        }

        headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.key) }
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeOut

        return urlRequest
    }
}
