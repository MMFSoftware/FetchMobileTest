import Foundation

enum RecipeAPIEndpoint: Endpoint {
    case allRecipes
    case emptyRecipes
    case errorRecipes

    var baseUrl: String { "https://d3jbb8n5wk0qxi.cloudfront.net/" }

    var path: String {
        switch self {
        case .allRecipes:
            return "recipes.json"
        case .emptyRecipes:
            return "recipes-empty.json"
        case .errorRecipes:
            return "recipes-malformed.json"
        }
    }

    var method: HTTPMethod { .get }

    var headers: [String: String]? { nil }

    var queryParams: [URLQueryItem]? { nil }
}
