import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
//                AsyncImage(url: URL(string: recipe.photoUrlSmall)) { image in
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                } placeholder: {
//                    Rectangle()
//                        .foregroundColor(.gray.opacity(0.2))
//                }
//                .frame(height: 200)
//                .clipShape(RoundedRectangle(cornerRadius: 15))

                if let url = URL(string: recipe.photoUrlSmall) {
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .foregroundColor(.gray.opacity(0.2))
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }

                Text(recipe.cuisine)
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.systemBackground)
                    .cornerRadius(15)
                    .padding()
            }

            Text(recipe.name)
                .font(.title3)
                .fontWeight(.semibold)
                .monospaced()

            Text(recipe.youtubeUrl ?? "")
                .foregroundColor(Color.secondary)
                .font(.caption)
        }
        .padding()
        .background(Color(.lightGreen))
        .cornerRadius(20)
    }
}

#Preview {
    RecipeCard(recipe: .fixture())
        .padding()
}
