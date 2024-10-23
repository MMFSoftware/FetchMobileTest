import SwiftUI

struct CategoryScrollView: View {
    let categories: [String]
    @State private var selectedCategory = "All"
    var onSelection: (String) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(selectedCategory == category ? Color("AccentGreen") : Color("LightGreen"))
                        .foregroundColor(selectedCategory == category ? .white : .black)
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                selectedCategory = category
                                onSelection(category)
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CategoryScrollView(categories: ["All", "Italian", "Brazilian", "Japanese"]) { _ in }
}
