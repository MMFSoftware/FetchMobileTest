import SwiftUI

// Main View
struct RecipesView: View {
    @StateObject private var viewModel = RecipesViewModel()
    @State private var isRefreshing = false
    @State private var showDebugMenu = false

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .loading:
                    loadingView
                        .foregroundColor(.accentGreen)
                case .ready:
                    readyView
                case .empty:
                    EmptyRecipesView()
                case .error(let errorMessage):
                    ErrorStateView(
                        message: errorMessage,
                        retryAction: { Task { await viewModel.fetchRecipes() } }
                    )
                }
            }
            .task {
                await viewModel.fetchRecipes()
            }
            .navigationTitle("Recipes")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
#if DEBUG
                    Button {
                        showDebugMenu = true
                    } label: {
                        Image(systemName: "ladybug.fill")
                    }
                    .tint(Color.accentGreen)
#endif
                }
            }
            .sheet(isPresented: $showDebugMenu) {
                DebugMenuView { _ in
                    // If we don't want to react to the debugMode change using Combine, we can manually
                    // call `fetchRecipes` when it changes by uncommenting the line bellow [FO]
                    // Task { await viewModel.fetchRecipes() }
                }
            }
        }
    }

    // MARK: - Loading View
    var loadingView: some View {
        ProgressView {
            Text("LOADING RECIPES")
                .monospaced()
                .foregroundColor(.primary)
        }
        .tint(.accentGreen)
    }

    // MARK: - Ready View
    var readyView: some View {
        Group {
            VStack(spacing: 0) {
                // MARK: Search Bar
                SearchBarView(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top)

                // MARK: Category Pills
                CategoryScrollView(categories: viewModel.cuisines, onSelection: viewModel.onCuisineSelection)
                    .padding(.vertical)

                // MARK: Popular Recipes List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredRecipes) { recipe in
                            RecipeCard(recipe: recipe)
                        }
                    }
                    .padding()
                }
                .refreshable {
                    await viewModel.fetchRecipes(isPullToRefresh: true)
                }
            }
        }
    }
}

#Preview {
    RecipesView()
}
