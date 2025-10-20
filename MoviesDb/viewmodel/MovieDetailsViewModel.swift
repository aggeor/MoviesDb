import Foundation
import Combine

@MainActor
class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetails?
    @Published var isLoadingDetails = false
    @Published var isLoadingCredits = false
    @Published var cast: [CastMember] = []

    func fetchDetails(for movieID: Int) async {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&language=en-US") else {
            print("Invalid URL")
            return
        }

        isLoadingDetails = true
        defer { isLoadingDetails = false }
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
    }
    
    func fetchCredits(for movieID: Int) async {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(apiKey)&language=en-US") else {
            print("Invalid URL")
            return
        }

        isLoadingCredits = true
        defer { isLoadingCredits = false }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                print("Server error")
                return
            }

            
            let decoded = try JSONDecoder().decode(Credits.self, from: data)
            cast = decoded.cast
        } catch {
            print("Error fetching movie details:", error)
        }
    }
}
