import Combine
@testable import FetchMobileTest
import Foundation
import Testing

struct RecipesViewModelTests {
    struct Mocks {
        let mockRecipesAPI: RecipeAPI.Mock
        let mockDebugManager: DebugManager.Mock
    }

    private func makeSut() -> (RecipesViewModel, Mocks) {
        let mockRecipesAPI = RecipeAPI.Mock()
        let mockDebugManager = DebugManager.Mock()
        return (
            RecipesViewModel(recipesAPI: mockRecipesAPI, debugManager: mockDebugManager),
            .init(mockRecipesAPI: mockRecipesAPI, mockDebugManager: mockDebugManager)
        )
    }

    // MARK: - State Tests
    @Test func testInitialState() throws {
        let (sut, _) = makeSut()
        #expect(sut.state == .loading)
        #expect(sut.recipes.isEmpty)
        #expect(sut.searchText.isEmpty)
    }

    // MARK: - Fetch Tests
    @Test func testFetchRecipesSuccess() async throws {
        let (sut, mocks) = makeSut()
        let mockRecipes = [Recipe.fixture()]
        mocks.mockRecipesAPI.fetchRecipesResultToReturn = .success(RecipesResponse(recipes: mockRecipes))

        await sut.fetchRecipes()

        #expect(sut.state == .ready)
        #expect(sut.recipes == mockRecipes)
    }

    @Test func testFetchRecipesEmpty() async throws {
        let (sut, mocks) = makeSut()
        mocks.mockRecipesAPI.fetchRecipesResultToReturn = .success(RecipesResponse(recipes: []))

        await sut.fetchRecipes()

        #expect(sut.state == .empty)
        #expect(sut.recipes.isEmpty)
    }

    @Test func testFetchRecipesError() async throws {
        let (sut, mocks) = makeSut()
        let error = NetworkError.invalidResponse
        mocks.mockRecipesAPI.fetchRecipesResultToReturn = .failure(error)

        await sut.fetchRecipes()

        #expect(sut.state == .error("Unable to load recipes. Please check your internet connection and try again."))
        #expect(sut.recipes.isEmpty)
    }

    // MARK: - Filter Tests
    @Test func testFilterByCuisine() throws {
        let (sut, _) = makeSut()
        sut.recipes = [
            .fixture(cuisine: "Italian"),
            .fixture(cuisine: "Japanese"),
            .fixture(cuisine: "Italian")
        ]

        sut.onCuisineSelection(cuisine: "Italian")
        #expect(sut.filteredRecipes.count == 2)
        #expect(sut.filteredRecipes.allSatisfy { $0.cuisine == "Italian" })
    }

    @Test func testFilterBySearch() async throws {
        let (sut, _) = makeSut()

        await MainActor.run {
            sut.recipes = [
                .fixture(name: "Pasta"),
                .fixture(name: "Sushi"),
                .fixture(name: "Pizza")
            ]
            sut.searchText = "pa"
            #expect(sut.filteredRecipes.count == 1)
            #expect(sut.filteredRecipes.first?.name == "Pasta")
        }
    }

    @Test func testFilterByCuisine() async throws {
        let (sut, _) = makeSut()

        await MainActor.run {
            sut.recipes = [
                .fixture(cuisine: "Italian"),
                .fixture(cuisine: "Japanese"),
                .fixture(cuisine: "Italian")
            ]
            sut.onCuisineSelection(cuisine: "Italian")
            #expect(sut.filteredRecipes.count == 2)
            #expect(sut.filteredRecipes.allSatisfy { $0.cuisine == "Italian" })
        }
    }

    @Test func testUniqueCuisines() async throws {
        let (sut, _) = makeSut()

        await MainActor.run {
            sut.recipes = [
                .fixture(cuisine: "Italian"),
                .fixture(cuisine: "Japanese"),
                .fixture(cuisine: "Italian")
            ]
            #expect(sut.cuisines == ["All", "Italian", "Japanese"])
        }
    }

    /*// MARK: - Debug Mode Tests
    @Test func testDebugModeEndpointSelection() async throws {
        let (sut, mocks) = makeSut()

        // Set up mock API to return empty data
        mocks.mockRecipesAPI.fetchRecipesResultToReturn = .success(RecipesResponse(recipes: []))

        // First wait for initial load to complete
        await sut.fetchRecipes()

        await confirmation("ViewModel should update state when debug endpoint changes") { done in
            await MainActor.run {
                // Start observing state changes
                sut.$state
                    .sink { state in
                        if case .empty = state {
                            done()
                        }
                    }
                    .store(in: &mocks.mockDebugManager.cancellables)

                // Then change the endpoint
                mocks.mockDebugManager.selectedEndpointValue = .empty
            }
        }

        #expect(sut.state == .empty)
    }*/
}
