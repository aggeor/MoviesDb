
struct MovieDetails: Hashable, Codable{
    let adult: Bool?
    let backdrop_path: String?
    let belongs_to_collection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdb_id: String?
    let origin_country: [String]?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Float?
    let poster_path: String?
    let production_companies: [ProductionCompany]
    let production_countries: [ProductionCountry]
    let release_date: String?
    let revenue: Int?
    let runtime: Int?
    let spoken_languages: [SpokenLanguage]
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let vote_average: Float?
    let vote_count: Int?
}

struct BelongsToCollection: Codable, Hashable {
    let id: Int?
    let name: String?
    let poster_path: String?
    let backdrop_path: String?
}


struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

struct SpokenLanguage: Codable, Hashable {
    let english_name: String
    let iso_639_1: String
    let name: String
}

struct ProductionCompany: Codable, Hashable {
    let id: Int?
    let logo_path: String?
    let name: String?
    let origin_country: String?
}

struct ProductionCountry: Codable, Hashable {
    let iso_3166_1: String?
    let name: String?
}
