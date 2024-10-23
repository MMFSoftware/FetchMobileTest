@testable import FetchMobileTest
import Foundation

extension RecipeAPI {
    class Mock: RecipeAPIProtocol {
        var fetchRecipesResultToReturn: Result<RecipesResponse, Error>? = .success(RecipesResponse(recipes: []))

        func fetchEmptyRecipes() async throws -> FetchMobileTest.RecipesResponse {
            try getReturnValue()
        }

        func fetchErrorRecipes() async throws -> FetchMobileTest.RecipesResponse {
            try getReturnValue()
        }

        func fetchAllRecipes() async throws -> RecipesResponse {
            try getReturnValue()
        }

        private func getReturnValue() throws -> RecipesResponse {
            switch fetchRecipesResultToReturn {
            case .success(let response):
                return response
            case .failure(let error):
                throw error
            default:
                fatalError("fetchAllRecipes was not set in RecipeAPI.Mock")
            }
        }
    }
}
