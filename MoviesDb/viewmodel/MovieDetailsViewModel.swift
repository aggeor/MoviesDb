import Foundation
import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetails?
    @Published var isLoading = false

    func fetchDetails(for movieID: Int) async {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&language=en-US&append_to_response=credits") else {
            print("Invalid URL")
            return
        }

        isLoading = true
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }

            let decoded = try JSONDecoder().decode(MovieDetails.self, from: data)
            movieDetail = decoded
        } catch {
            print("Error fetching movie details:", error)
        }
        isLoading = false
    }
}
