import Foundation

public class GenericEndpoint: Endpoint {
    public var baseUrl: String { "" }
    public var path: String { "" }
    public var method: HTTPMethod
    public var url: String
    public var httpMethod: HTTPMethod = .get
    public var queryParams: [URLQueryItem]?

    init(url: String, method: HTTPMethod = .get, queryParams: [URLQueryItem]? = nil) {
        self.method = method
        self.url = url
        self.queryParams = queryParams?.sorted(by: { $0.name < $1.name })
    }
}
