
struct APIMovieDetails: Hashable, Codable{
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: APIBelongsToCollection?
    let budget: Int?
    let genres: [APIGenre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let productionCompanies: [APIProductionCompany]
    let productionCountries: [APIProductionCountry]
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [APISpokenLanguage]
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case adult, budget, genres, homepage, id, overview, popularity, revenue, runtime, status, tagline, title, video
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

struct APIBelongsToCollection: Codable, Hashable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}


struct APIGenre: Codable, Hashable {
    let id: Int
    let name: String
}

struct APISpokenLanguage: Codable, Hashable {
    let englishName: String
    let iso_639_1: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case iso_639_1, name
        case englishName = "english_name"
    }
}

struct APIProductionCompany: Codable, Hashable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct APIProductionCountry: Codable, Hashable {
    let iso_3166_1: String?
    let name: String?
}
