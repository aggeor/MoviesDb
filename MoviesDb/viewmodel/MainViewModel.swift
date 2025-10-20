import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var title: String = "Popular Movies"

    var lastSearchText: String? = nil
    private var currentPage = 1
    private var totalPages = 1
    var isLoading = false
    private var searchQuery: String? = nil

    func search(_ query: String?) async {
        lastSearchText = query
        searchQuery = query?.trimmingCharacters(in: .whitespacesAndNewlines)
        currentPage = 1
        movies = []

        if let query = searchQuery, !query.isEmpty {
            title = "Search results for: \(query)"
        } else {
            title = "Popular Movies"
        }

        await fetchMovies(page: currentPage)
    }

    func fetchNextIfNeeded(currentMovie: Movie) async {
        guard currentPage < totalPages else { return }
        guard let lastMovie = movies.last, lastMovie.id == currentMovie.id else { return }
        
        currentPage += 1
        await fetchMovies(page: currentPage)
    }

    private func fetchMovies(page: Int) async {
        let urlString: String
        if let query = searchQuery, !query.isEmpty {
            let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            urlString = "https://api.themoviedb.org/3/search/multi?api_key=\(apiKey)&query=\(escapedQuery)&page=\(page)"
        } else {
            urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)"
        }

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }

            let movieWrapper = try JSONDecoder().decode(MovieDataWrapper.self, from: data)
            totalPages = movieWrapper.total_pages
            movies.append(contentsOf: movieWrapper.results)
            movies = movies.filter { $0.title != nil && $0.poster_path != nil }
            print("Fetched page \(page), total movies: \(movies.count)")
        } catch {
            print("Failed to fetch or decode movies:", error)
        }
    }
}
