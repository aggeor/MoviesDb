import SwiftUI

struct MovieDetailView: View {
    let movieID: Int
    @StateObject private var viewModel = MovieDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private let headerHeight: CGFloat = 250
    
    init(movieID: Int) {
            self.movieID = movieID
            
            // Make Navigation Bar transparent
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // MARK: - Header image
            if let backdropPath = viewModel.movieDetail?.backdrop_path,
               let url = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)") {
                imageView(url: url)
                    .frame(height: headerHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()
            } else {
                Color.gray
                    .frame(height: headerHeight)
                    .frame(maxWidth: .infinity)
            }
            
            // MARK: - Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    // Spacer to push content below header
                    Color.clear
                        .frame(height: headerHeight)
                    
                    if viewModel.isLoadingDetails {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                    } else if let movie = viewModel.movieDetail {
                        textsView(movie: movie)
                            .padding(.horizontal, 24)
                    } else {
                        Text("Failed to load movie details")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            
            
        }
        .background(Color.black)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .task {
            await fetchMovieData()
        }
        .toolbar{
            ToolbarItem(placement: .topBarLeading) {
                // MARK: - Back button
                backBtnView
                    .padding(.top, 8) // adjust for safe area
            }
        }
    }
    
    @MainActor
    func fetchMovieData() async {
        await viewModel.fetchDetails(for: movieID)
        await viewModel.fetchCredits(for: movieID)
    }
    
    var backBtnView: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
    }
    
    func imageView(url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    )
            case .failure:
                Color.gray
            @unknown default:
                EmptyView()
            }
        }
    }
    
    func textsView(movie: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title ?? "")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            if !movie.genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(movie.genres, id: \.id) { genre in
                            Text(genre.name)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.yellow.opacity(0.3))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            
            HStack(spacing: 8) {
                if let releaseDate = movie.release_date, !releaseDate.isEmpty {
                    Text(releaseDate)
                }
                if let runtime = movie.runtime {
                    Text("• \(runtime) min")
                }
                if let rating = movie.vote_average {
                    Text("• ⭐️ \(String(format: "%.1f", rating))")
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            Divider()
                .background(Color.gray)
                .padding(.vertical, 8)
            
            Text(movie.overview ?? "")
                .foregroundColor(.white)
                .font(.body)
                .lineSpacing(4)
            if !viewModel.cast.isEmpty {
                castView(cast: viewModel.cast)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 40)
        .background(.black)
        .cornerRadius(32)
    }
    
    func castView(cast: [CastMember]) -> some View {
        VStack(alignment: .leading) {
            Text("Cast")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cast) { member in
                        VStack(alignment: .center) {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(member.profile_path ?? "")")) { phase in
                                switch phase {
                                case .empty:
                                    Color.gray
                                        .frame(width: 100, height: 140)
                                        .cornerRadius(8)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 140)
                                        .clipped()
                                        .cornerRadius(8)
                                case .failure:
                                    Color.gray
                                        .frame(width: 100, height: 140)
                                        .cornerRadius(8)
                                @unknown default:
                                    EmptyView()
                                }
                            }

                            Text(member.name ?? "")
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 100)
                                .lineLimit(1)
                            Text(member.character ?? "")
                                .font(.caption2)
                                .foregroundColor(.gray)
                                .frame(width: 100)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }

}
