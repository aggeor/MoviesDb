import SwiftUI

struct MovieCard: View {
    var movie: Movie
    
    // Adjust frame for each movie card
    let frameWidth = UIScreen.main.bounds.width / 2.3
    let frameHeight = UIScreen.main.bounds.height / 3.87
    
    var body: some View {
        ZStack{
            if let posterPath = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                imageView(url:url)
            } else {
                Color.gray
                    .frame(width: frameWidth, height: frameHeight)
                    .cornerRadius(12)
            }
            textsView
        }
    }
    
    func imageView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: frameWidth, height: frameHeight)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: frameWidth, height: frameHeight)
                    .clipped()
                    .cornerRadius(12)
                    .overlay{
                        LinearGradient(colors: [.black, .clear], startPoint: UnitPoint(x: 0.0, y: 0.8), endPoint: UnitPoint(x: 0.0, y: 0.5))
                    }
            case .failure:
                Color.gray
                    .frame(width: frameWidth, height: frameHeight)
                    .cornerRadius(12)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    var textsView: some View {
        VStack(alignment: .leading,spacing: 8){
            Text(movie.title ?? "")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .lineLimit(1)
            if let releaseDate = movie.releaseDate{
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
