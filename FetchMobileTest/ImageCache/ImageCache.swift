import SwiftUI

actor ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    private func cacheKey(for url: URL) -> String? {
        guard let data = url.absoluteString.data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString()
    }

    func image(for url: URL) async throws -> UIImage? {
        guard let keyString = cacheKey(for: url) else {
            throw URLError(.badURL)
        }

        let key = keyString as NSString

        // Check memory cache first
        if let cachedImage = cache.object(forKey: key) {
            return cachedImage
        }

        // Check disk cache
        let imagePath = cacheDirectory.appendingPathComponent(keyString)
        if fileManager.fileExists(atPath: imagePath.path),
           let data = try? Data(contentsOf: imagePath),
           let image = UIImage(data: data) {
            cache.setObject(image, forKey: key)
            return image
        }

        // Download and cache
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }

        // Save to memory cache
        cache.setObject(image, forKey: key)

        // Save to disk cache
        try data.write(to: imagePath)

        return image
    }

    func clearCache() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}
