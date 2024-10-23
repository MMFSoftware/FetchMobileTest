import SwiftUI

struct EmptyRecipesView: View {
    @State private var isAnimating = false
    @State private var iconOffset: CGFloat = 0

    var body: some View {
        GroupBox {
            VStack(spacing: 16) {
                Image(systemName: "fork.knife.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.accentGreen)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .offset(y: iconOffset)
                    .animation(.spring(duration: 2).repeatForever(autoreverses: true), value: iconOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: false)) {
                            isAnimating = true
                        }
                        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                            iconOffset = -10
                        }
                    }

                Text("No Recipes Found")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.3), value: isAnimating)

                Text("Try adjusting your search or filters to find what you're looking for")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.5), value: isAnimating)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
        }
        .padding()
    }
}

// MARK: - Preview
#Preview {
    EmptyRecipesView()
}
