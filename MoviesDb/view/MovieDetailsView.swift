import SwiftUI

struct MovieDetailView: View {
    let movieID: Int
    @StateObject private var viewModel = MovieDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    private let headerHeight: CGFloat = 250
    
    init(movieID: Int) {
        self.movieID = movieID
        // Transparent navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            headerView
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 8) {
                    Color.clear.frame(height: headerHeight)
                    
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
                    
                    if !viewModel.cast.isEmpty {
                        castView(cast: viewModel.cast)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
        .background(Color.black)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .task { await fetchMovieData() }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                backBtnView
                    .tint(.white)
            }
        }
    }
    
    @MainActor
    func fetchMovieData() async {
        await viewModel.fetchDetails(for: movieID)
        await viewModel.fetchCredits(for: movieID)
    }
    
    var headerView: some View {
        ZStack {
            if let imagePath = viewModel.movieDetail?.backdropPath ?? viewModel.movieDetail?.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w780\(imagePath)") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        placeholderHeader
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderHeader
                    @unknown default:
                        placeholderHeader
                    }
                }
            } else {
                placeholderHeader
            }
        }
        .frame(width: UIScreen.main.bounds.width,height: headerHeight)
        .overlay(headerGradient)
        .clipped()
    }

    var placeholderHeader: some View {
        Color.gray
    }

    var headerGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.black.opacity(0.0), Color.black]),
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 100)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    var backBtnView: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "chevron.left")
        }
    }
    
    func textsView(movie: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title ?? "").font(.title).bold().foregroundColor(.white)
            
            if !movie.genres.isEmpty {
                genresView(movie: movie)
            }
            
            infoView(movie: movie)
            
            
            if let status = movie.status {
                Text("\(status)")
                    .font(.body)
                    .foregroundColor(status=="Released" ? .green : .red)
            }
            
            linksView(movie: movie)
            
            Divider().background(Color.gray).padding(.vertical, 8)
            
            Text(movie.overview ?? "")
                .foregroundColor(.white)
                .font(.body)
                .lineSpacing(4)
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .background(.black)
        .cornerRadius(32)
        .frame(width: UIScreen.main.bounds.width)
    }
    
    func genresView(movie: MovieDetails) -> some View {
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
    
    func infoView(movie: MovieDetails) -> some View {
        HStack(spacing: 8) {
            if let releaseDate = movie.releaseDate {
                Text(formatDate(releaseDate))
            }
            if let runtime = movie.runtime {
                Text("• \(runtime) min")
            }
            if let rating = movie.voteAverage, let voteCount = movie.voteCount {
                Text("• ⭐️ \(String(format: "%.1f", rating)) (\(voteCount))")
            }
        }
        .font(.subheadline)
        .foregroundColor(.gray)
    }
    
    func linksView(movie: MovieDetails) -> some View {
        HStack(spacing: 8) {
            NavigationLink(destination: WebView(url: "https://www.themoviedb.org/movie/\(movie.id)")){
                Text("TMDB")
                    .font(.body)
                    .padding(4)
                    .foregroundColor(.white)
                    .background(.blue.opacity(0.7))
                    .cornerRadius(10)
            }
            
            
            if let imdbId = movie.imdbId {
                NavigationLink(destination: WebView(url: "https://www.imdb.com/title/\(imdbId)")){
                    Text("IMDb")
                        .font(.body)
                        .padding(4)
                        .foregroundColor(.white)
                        .background(.yellow.opacity(0.7))
                        .cornerRadius(10)
                }
            }
        }
    }
    
    func castView(cast: [CastMember]) -> some View {
        VStack(alignment: .leading) {
            Divider().background(Color.gray).padding(.vertical, 8)
            Text("Cast").font(.headline).foregroundColor(.white).padding(.bottom, 4)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(cast) { member in
                        NavigationLink(destination: WebView(url: "https://themoviedb.org/person/\(member.id)")){
                            VStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w185\(member.profilePath ?? "")")) { phase in
                                    switch phase {
                                    case .empty: Color.gray.frame(width: 100, height: 140).cornerRadius(8)
                                    case .success(let image):
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 140)
                                            .clipped()
                                            .cornerRadius(8)
                                    case .failure: Color.gray.frame(width: 100, height: 140).cornerRadius(8)
                                    @unknown default: EmptyView()
                                    }
                                }
                                Text(member.name ?? "").font(.caption).foregroundColor(.white).frame(width: 100).lineLimit(1)
                                Text(member.character ?? "").font(.caption2).foregroundColor(.gray).frame(width: 100).lineLimit(1)
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom, 8)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width)
    }
}
