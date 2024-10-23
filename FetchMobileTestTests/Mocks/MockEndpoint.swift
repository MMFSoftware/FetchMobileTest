@testable import FetchMobileTest
import Foundation

struct MockEndpoint: Endpoint {
    var baseUrl: String = ""
    var path: String = ""
    var method: FetchMobileTest.HTTPMethod = .get
    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
    }

    func url() -> URL? {
        URL(string: urlString)
    }

    func asURLRequest() -> URLRequest? {
        guard let url = url() else { return nil }
        return URLRequest(url: url)
    }
}
