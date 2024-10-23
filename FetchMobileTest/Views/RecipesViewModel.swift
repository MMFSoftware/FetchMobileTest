import Combine
import SwiftUI

class RecipesViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case ready
        case empty
        case error(String)
    }
    // MARK: - Dependencies
    private let recipesAPI: RecipeAPIProtocol
    private let debugManager: DebugManagerProtocol

    // MARK: - Private
    private var cancellables = Set<AnyCancellable>()

    init(
        recipesAPI: RecipeAPIProtocol = RecipeAPI(),
        debugManager: DebugManagerProtocol = DebugManager.shared
    ) {
        self.recipesAPI = recipesAPI
        self.debugManager = debugManager
        // If you want to test the retry button, comment out the next line [FO]
        bind()
    }

    private func bind() {
        debugManager.selectedEndpointPublisher
            .sink { _ in
                Task {
                    await self.fetchRecipes()
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Published
    @Published var recipes: [Recipe] = []
    @Published var searchText: String = ""
    @Published var state: State = .loading
    @Published private var cuisineFilter: String?

    func fetchRecipes(isPullToRefresh: Bool = false) async {
        if !isPullToRefresh {
            await MainActor.run {
                state = .loading
            }
        }

        do {
            let recipesResponse: RecipesResponse = try await {
                switch debugManager.selectedEndpointValue {
                case .regular:
                    return try await recipesAPI.fetchAllRecipes()
                case .malformed:
                    return try await recipesAPI.fetchErrorRecipes()
                case .empty:
                    return try await recipesAPI.fetchEmptyRecipes()
                }
            }()

            await MainActor.run {
                recipes = recipesResponse.recipes
                state = recipes.isEmpty ? .empty : .ready
            }
        } catch {
            print("🔴 Error fetching recipes: \(error)")
            await MainActor.run {
                state = .error("Unable to load recipes. Please check your internet connection and try again.")
            }
        }
    }

    var filteredRecipes: [Recipe] {
        let allRecipes: [Recipe]
        if let cuisineFilter, cuisineFilter != "All" {
            allRecipes = recipes.filter { $0.cuisine == cuisineFilter }
        } else {
            allRecipes = recipes
        }
        if searchText.isEmpty {
            return allRecipes
        } else {
            return allRecipes.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var cuisines: [String] {
        ["All"] + Array(Set(recipes.map { $0.cuisine })).sorted()
    }

    func onCuisineSelection(cuisine: String) {
        cuisineFilter = cuisine
    }
}
