import Foundation

struct RecipesResponse: Decodable {
    let recipes: [Recipe]
}

struct Recipe: Decodable, Identifiable, Equatable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String
    let photoUrlSmall: String
    let sourceUrl: String?
    let uuid: String
    let youtubeUrl: String?
    var id: String { uuid }

    enum CodingKeys: String, CodingKey {
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case uuid
        case youtubeUrl = "youtube_url"
    }
}

/// Create a Fixture for Recipe for testing and previews
extension Recipe {
    static func fixture(
        cuisine: String = "Italian",
        name: String = "Test Recipe",
        photoUrlLarge: String = "https://example.com/large.jpg",
        photoUrlSmall: String = "https://example.com/small.jpg",
        sourceUrl: String? = "https://example.com/recipe",
        uuid: String = "test-uuid",
        youtubeUrl: String? = "https://youtube.com/watch"
    ) -> Recipe {
        .init(
            cuisine: cuisine,
            name: name,
            photoUrlLarge: photoUrlLarge,
            photoUrlSmall: photoUrlSmall,
            sourceUrl: sourceUrl,
            uuid: uuid,
            youtubeUrl: youtubeUrl
        )
    }
}
