
# Recipe Browser App

A SwiftUI app that allows users to browse, search, and filter recipes by cuisine from an API.

## Steps to Run the App
- Requires Xcode 16
- No additional configuration or build steps needed
- Just clone, build, and run!

## Focus Areas
I prioritized the following areas in this project:

### Architecture & Code Quality
- Implemented MVVM architecture with state management
- Focused on clean, maintainable, and testable code
- Created reusable SwiftUI components
- Organized codebase for scalability
- **SOLID principles** were the cornerstone of the code to ensure quality, maintainability, and scalability.

### Version Control
Everything was done before creating the GitHub repo, so it ended up with just one commit. Normally, I’d have multiple commits to show incremental progress.

### User Experience
- Smooth and reactive interface
- Comprehensive error handling with user-friendly error states
- Empty state handling with appropriate feedback
- Search and filter capabilities
- **Pull-to-refresh** functionality to reload the recipe list easily.
- Debug menu for testing different states (error/empty)
- Support for **light and dark mode**.
- Support for **portrait and landscape orientations** to provide a flexible layout across devices.

### Image Caching
- Implemented efficient image caching using an `ImageCache` class.
- Images are first checked in memory (using `NSCache`).
- If not in memory, images are retrieved from the disk cache stored in the app's cache directory.
- If neither cache contains the image, it's downloaded from the network and stored both in memory and on disk.
- The cache can be cleared manually, and it automatically saves space for future use by reusing stored images efficiently.

### Pull-to-Refresh
- Added pull-to-refresh functionality to allow users to reload the recipe list by pulling down on the screen.
- The pull-to-refresh control is integrated into the SwiftUI List, which triggers a reload of the recipes from the API.

Example SwiftUI code for pull-to-refresh:

```swift
List {
    ForEach(viewModel.recipes) { recipe in
        RecipeRow(recipe: recipe)
    }
}
.refreshable {
    await viewModel.loadRecipes()
}
```

### Testing
- Extensive unit test coverage
- Focus on testable architecture
- Custom test helpers and mocks

## Time Spent
Total time: 6 hours

Time allocation:
- Initial setup: 10%
- Networking layer: 20%
- UI Implementation: 30%
- Testing: 30%
- Polish and refinements: 10%

## Trade-offs and Decisions
- Prioritized essential UX features over nice-to-have additions
- Focused on core functionality first (listing, searching, filtering)
- Created a solid foundation for future enhancements
- Emphasized code quality and testing over feature quantity

### Additional Features Implemented
- Cuisine filter functionality
- Debug menu for testing error states and empty states
- Clean error handling and user feedback

## Weakest Part of the Project
The main area for improvement would be:
- Combine testing could be more comprehensive
- Recipe detail screen could be implemented
- Additional UI polish and animations could be added

## External Code and Dependencies
- No third-party libraries used
- Built entirely with native SwiftUI and Combine

## Additional Information
### Challenges
- Working with the new Swift Testing framework in Xcode 16 presented some learning opportunities
- Balancing feature scope with time constraints

### Bonus Features
1. Filter by cuisine type
2. Debug menu with multiple endpoints for testing:
    - Regular endpoint
    - Error state endpoint
    - Empty state endpoint

### Future Improvements
- Add recipe detail view
- Enhance UI animations
- Add more filter options
- Implement favorites functionality
- Open the Youtube link when tapping the recipe
