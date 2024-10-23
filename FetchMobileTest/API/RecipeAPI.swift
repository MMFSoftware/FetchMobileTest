import Foundation

protocol RecipeAPIProtocol {
    func fetchAllRecipes() async throws -> RecipesResponse
    func fetchEmptyRecipes() async throws -> RecipesResponse
    func fetchErrorRecipes() async throws -> RecipesResponse
}

class RecipeAPI: RecipeAPIProtocol {
    let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }

    func fetchAllRecipes() async throws -> RecipesResponse {
        try await networkClient.fetch(endpoint: RecipeAPIEndpoint.allRecipes)
    }

    func fetchEmptyRecipes() async throws -> RecipesResponse {
        try await networkClient.fetch(endpoint: RecipeAPIEndpoint.emptyRecipes)
    }

    func fetchErrorRecipes() async throws -> RecipesResponse {
        try await networkClient.fetch(endpoint: RecipeAPIEndpoint.errorRecipes)
    }
}
