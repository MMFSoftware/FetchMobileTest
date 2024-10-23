import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @State private var image: UIImage?
    @State private var isLoading = false

    init(
        url: URL?,
        scale: CGFloat = 1,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.content = content
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard !isLoading, let url else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            if let cachedImage = try await ImageCache.shared.image(for: url) {
                await MainActor.run {
                    self.image = cachedImage
                }
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
