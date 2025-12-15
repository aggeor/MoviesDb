import Foundation

struct Movies: Decodable {
    let page: Int?
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int?
}

struct Movie: Hashable, Codable, Sendable{
    let adult: Bool?
    let backdropPath: String?
    let genreIds: [Int]?
    let id: Int
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let releaseDate: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?
}


extension Movies {
    init(from response: APIMovies) {
        self.page = response.page
        self.results = response.results.map(Movie.init)
        self.totalPages = response.totalPages
        self.totalResults = response.totalResults
    }
}


extension Movie {
    nonisolated init(from response: APIMovie) {
        self.adult = response.adult
        self.backdropPath = response.backdropPath
        self.genreIds = response.genreIds
        self.id = response.id
        self.originalLanguage = response.originalLanguage
        self.originalTitle = response.originalTitle
        self.overview = response.overview
        self.popularity = response.popularity
        self.posterPath = response.posterPath
        self.releaseDate = response.releaseDate
        self.title = response.title
        self.video = response.video
        self.voteAverage = response.voteAverage
        self.voteCount = response.voteCount
    }
}
