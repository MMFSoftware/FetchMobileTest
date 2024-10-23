import Foundation

public protocol NetworkClientProtocol {
    func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T
    func fetch<T: Decodable>(endpoint: Endpoint, shouldClearCache: Bool) async throws -> T
    func fetchAndSave(endpoint: Endpoint, fileName: String, shouldClearCache: Bool) async throws
}

public class NetworkClient: NetworkClientProtocol {
    // MARK: - Dependecies
    let urlSession: URLSessionProtocol

    // MARK: - Properties
    private let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        return config
    }()

    public init(session: URLSessionProtocol) {
        self.urlSession = session
    }

    public init() {
        self.urlSession = URLSession(configuration: configuration)
    }

    // MARK: - Helpers
    private func getResponseError(response: URLResponse) -> NetworkError? {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return .requestFailed(error: "No status code")
        }
        guard isSuccess(statusCode) else {
            return .responseUnsuccessful(statusCode: statusCode)
        }
        return nil
    }

    private func isSuccess(_ statusCode: Int) -> Bool { 200..<300 ~= statusCode }

    private func clearCache(shouldClearCache: Bool, urlRequest: URLRequest) {
        if shouldClearCache {
            URLCache.shared.removeCachedResponse(for: urlRequest)
            print("⎊ Cache cleared for \(urlRequest.url?.absoluteString ?? "unknown")")
        }
    }

    public func fetch<T: Decodable>(endpoint: Endpoint) async throws -> T {
        try await fetch(endpoint: endpoint, shouldClearCache: false)
    }

    public func fetch<T: Decodable>(endpoint: Endpoint, shouldClearCache: Bool) async throws -> T {
        let data = try await request(endpoint: endpoint, shouldClearCache: shouldClearCache)
        let endpointUrl = endpoint.url()?.absoluteString ?? "nil"
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch let DecodingError.keyNotFound(key, context) {
            let failingKeyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            NetworkLogger.logError(
                on: endpointUrl,
                message: "JSON Parsing Error: Failed to decode due to missing key '\(key.stringValue)' not found at \(failingKeyPath) – \(context.debugDescription)"
            )
            throw NetworkError.jsonParsingFailure(error: "Missing key '\(key.stringValue)' at \(failingKeyPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            let failingKeyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            NetworkLogger.logError(on: endpointUrl, message: "JSON Parsing Error: Failed to decode due to missing \(value) value at \(failingKeyPath) – \(context.debugDescription)")
            throw NetworkError.jsonParsingFailure(error: "Missing \(value) value at \(failingKeyPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            let failingKeyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            NetworkLogger.logError(on: endpointUrl, message: "JSON Parsing Error: Failed to decode due to type mismatch for \(type) at \(failingKeyPath) – \(context.debugDescription)")
            throw NetworkError.jsonParsingFailure(error: "Type mismatch for \(type) at \(failingKeyPath)")
        } catch let DecodingError.dataCorrupted(context) {
            let failingKeyPath = context.codingPath.map { $0.stringValue }.joined(separator: ".")
            NetworkLogger.logError(on: endpointUrl, message: "JSON Parsing Error: Failed to decode due to data being corrupted at \(failingKeyPath) – \(context.debugDescription)")
            throw NetworkError.jsonParsingFailure(error: "Data corrupted at \(failingKeyPath)")
        } catch let error {
            NetworkLogger.logError(on: endpointUrl, message: "JSON Parsing Error: \(error.localizedDescription)")
            throw NetworkError.jsonParsingFailure(error: error.localizedDescription)
        }
    }
    // swiftlint:enable line_length

    @discardableResult
    private func request(endpoint: Endpoint, shouldClearCache: Bool) async throws -> Data {
        guard let request = endpoint.asURLRequest() else { throw NetworkError.invalidRequest }

        clearCache(shouldClearCache: shouldClearCache, urlRequest: request)
        NetworkLogger.logRequest(request: request)

        do {
            let (data, response) = try await urlSession.data(for: request, delegate: nil)
            NetworkLogger.logResponse(response, data)

            if let errorParsed = self.getResponseError(response: response) {
                NetworkLogger.logResponseError(response, data)
                throw errorParsed
            }
            return data
        } catch let error as NetworkError {
            NetworkLogger.logError(on: request.url?.absoluteString, message: error.localizedDescription)
            throw error
        } catch {
            NetworkLogger.logError(on: request.url?.absoluteString, message: error.localizedDescription)
            throw NetworkError.requestFailed(error: String(describing: error))
        }
    }
}

// MARK: - Saving Responses to files
public extension NetworkClient {
    private func saveResponseToFile(data: Data, fileName: String) async throws {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL)
            print("Response saved to file: \(fileURL.absoluteString)")
        } catch {
            print("🔴 " + "Failed to save response to file: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchAndSave(endpoint: Endpoint, fileName: String, shouldClearCache: Bool = false) async throws {
        let data = try await request(endpoint: endpoint, shouldClearCache: shouldClearCache)
        try await saveResponseToFile(data: data, fileName: fileName)
    }
}
