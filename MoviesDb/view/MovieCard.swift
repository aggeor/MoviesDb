import SwiftUI

struct MovieCard: View {
    var movie: Movie
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    private var isLandscape: Bool {
        horizontalSizeClass == .regular || verticalSizeClass == .compact
    }
    
    private var cardWidth: CGFloat {
        isLandscape ? 340 : 160
    }
    
    private var cardHeight: CGFloat {
        isLandscape ? 160 : 240
    }
    
    var body: some View {
        ZStack {
            if let posterPath = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                imageView(url: url)
            } else {
                Color.gray
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(12)
            }
            textsView
        }
        .frame(width: cardWidth, height: cardHeight)
        .contentShape(Rectangle())
    }
    
    func imageView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: cardWidth, height: cardHeight)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: cardWidth, height: cardHeight)
                    .clipped()
                    .cornerRadius(12)
                    .overlay {
                        LinearGradient(
                            colors: [.black, .clear],
                            startPoint: UnitPoint(x: 0.0, y: 0.8),
                            endPoint: UnitPoint(x: 0.0, y: 0.5)
                        )
                    }
            case .failure:
                Color.gray
                    .frame(width: cardWidth, height: cardHeight)
                    .cornerRadius(12)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    var textsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title ?? "")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .lineLimit(1)
            if let releaseDate = movie.releaseDate {
                Text(formatDate(releaseDate))
                    .foregroundColor(.white)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
    }
}
