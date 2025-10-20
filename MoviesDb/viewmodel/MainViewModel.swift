import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false

    func fetchFirst() async {
        currentPage = 1
        movies = [] // clear previous results on first fetch
        await fetchMovies(page: currentPage)
    }

    func fetchNextIfNeeded(currentMovie: Movie) async {
        // Trigger next fetch only when last movie appears
        guard let lastMovie = movies.last, currentMovie.id == lastMovie.id else { return }
        await fetchNextPage()
    }

    private func fetchNextPage() async {
        guard !isLoading, currentPage < totalPages else { return }
        currentPage += 1
        await fetchMovies(page: currentPage)
    }

    private func fetchMovies(page: Int) async {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&page=\(page)") else {
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

            // Append new results instead of replacing
            movies.append(contentsOf: movieWrapper.results)
            print("Fetched page \(page), total movies: \(movies.count)")

        } catch {
            print("Failed to fetch or decode movies:", error)
        }
    }
}
