import Foundation
internal import Combine

@MainActor
class MainViewModel: ObservableObject {
    @Published var movies: [Movie] = []

    func fetchFirst() async {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)") else {
            print("Invalid URL")
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Server error or invalid status code")
                return
            }

            let movieWrapper = try JSONDecoder().decode(MovieDataWrapper.self, from: data)
            self.movies = movieWrapper.results
            print("Decoded \(self.movies.count) movies")

        } catch {
            print("Failed to fetch or decode movies:", error)
        }
    }
}
