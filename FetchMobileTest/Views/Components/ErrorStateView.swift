import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    @State private var isAnimating = false
    @State private var iconOffset: CGFloat = 0

    var body: some View {
        GroupBox {
            VStack(spacing: 20) {
                // MARK: Animated Icon
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                    .rotationEffect(.degrees(isAnimating ? 16 : -16))
                    .offset(y: iconOffset)
                    .animation(
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                        value: isAnimating
                    )

                // MARK: Error Title
                Text("Oops!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.3), value: isAnimating)

                // MARK: Error Message
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.easeIn(duration: 0.5).delay(0.5), value: isAnimating)

                // MARK: Retry Button
                Button(action: retryAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentGreen)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1 : 0.8)
                .animation(.spring(duration: 0.6).delay(0.7), value: isAnimating)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 32)
        }
        .padding()
        .onAppear {
            isAnimating = true
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                iconOffset = -10
            }
        }
    }
}

// MARK: - Preview
#Preview {
    Group {
        ErrorStateView(
            message: "Unable to load recipes. Please check your internet connection and try again.",
            retryAction: { print("Retry tapped") }
        )

        ErrorStateView(
            message: "Error loading recipes",
            retryAction: { print("Retry tapped") }
        )
    }
}
