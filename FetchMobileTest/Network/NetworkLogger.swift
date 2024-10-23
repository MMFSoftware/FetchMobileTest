import Foundation

public class NetworkLogger {
    static var verbose: Bool {
        ProcessInfo.processInfo.arguments.contains("-verboseLogging")
    }

    static var disableNetworkLogging: Bool {
        ProcessInfo.processInfo.arguments.contains("-disableNetworkLogging")
    }

    static func logRequest(request: URLRequest) {
#if DEBUG
        guard !disableNetworkLogging else { return }
        if NetworkLogger.verbose {
            let log = "⎊ REQUEST - URL: \(request.url?.absoluteString ?? "")"
            + ", METHOD: \(request.httpMethod ?? "")"
            + ((request.allHTTPHeaderFields != nil) ? ", HEADERS: \(request.allHTTPHeaderFields ?? [:])" : "")
            print(log)
        } else {
            let log = "⎊ REQUEST - URL: \(request.url?.absoluteString ?? "")"
            print(log)
        }
#endif
    }

    static func logResponse(_ response: URLResponse?, _ data: Data?) {
#if DEBUG
        guard !disableNetworkLogging else { return }
        let url = response?.url?.absoluteString ?? ""
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        let logHeader = "⎊ RESPONSE - URL: \(url), STATUS_CODE: \(statusCode)"

        if NetworkLogger.verbose {
            let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: String] ?? [:]
            var responseData = "NO DATA"
            if let dataObj = data, let validResponseData = String(data: dataObj, encoding: .utf8) {
                responseData = validResponseData
            } else {
                responseData = "INVALID DATA"
            }

            let log = "\(logHeader), HEADERS: \(headers), DATA: \(responseData)"
            print(log)
        } else {
            print(logHeader)
        }
#endif
    }

    static func logResponseError(_ response: URLResponse?, _ data: Data?) {
#if DEBUG
        guard !disableNetworkLogging else { return }
        let url = response?.url?.absoluteString ?? ""
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        if NetworkLogger.verbose {
            let headers = (response as? HTTPURLResponse)?.allHeaderFields as? [String: String] ?? [:]
            var responseData = "NO DATA"
            if let dataObj = data {
                responseData = String(data: dataObj, encoding: .utf8) ?? "INVALID DATA"
            }
            let log = "⎊ RESPONSE ERROR - URL: \(url)"
            + ", STATUS_CODE: \(statusCode), HEADERS: \(headers), DATA: \(responseData)"
            print("🔴 " + log)
        } else {
            let log = "⎊ RESPONSE ERROR - URL: \(url), STATUS_CODE: \(statusCode)"
            print("🔴 " + log)
        }
#endif
    }

    static func logError(on requestUrl: String?, message: String) {
#if DEBUG
        guard !disableNetworkLogging else { return }
        let url = requestUrl ?? "NO URL"
        let log = "⎊ NETWORK ERROR: URL=\(url), ERROR=\(message)"
        print("🔴 " + log)
#endif
    }
}
