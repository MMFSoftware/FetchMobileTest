import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            TextField("Search...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }

            Image(systemName: "mic.fill")
                .foregroundColor(.gray)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    VStack(spacing: 20) {
        SearchBarView(text: .constant(""))
        SearchBarView(text: .constant("Apple"))
        SearchBarView(text: .constant("Very long search term that should wrap"))
    }
    .padding()
}
