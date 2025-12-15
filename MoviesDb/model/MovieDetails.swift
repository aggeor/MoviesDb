
struct MovieDetails: Hashable, Codable{
    let adult: Bool?
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int?
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbId: String?
    let originCountry: [String]?
    let originalLanguage: String?
    let originalTitle: String?
    let overview: String?
    let popularity: Float?
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String?
    let revenue: Int?
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]
    let status: String?
    let tagline: String?
    let title: String?
    let video: Bool?
    let voteAverage: Float?
    let voteCount: Int?
}


extension MovieDetails {
    init(from response: APIMovieDetails) {
        self.adult = response.adult
        self.backdropPath = response.backdropPath
        self.belongsToCollection = response.belongsToCollection.map(BelongsToCollection.init)
        self.budget = response.budget
        self.genres = response.genres.map(Genre.init)
        self.homepage = response.homepage
        self.id = response.id
        self.imdbId = response.imdbId
        self.originCountry = response.originCountry
        self.originalLanguage = response.originalLanguage
        self.originalTitle = response.originalTitle
        self.overview = response.overview
        self.popularity = response.popularity
        self.posterPath = response.posterPath
        self.productionCompanies = response.productionCompanies.map(ProductionCompany.init)
        self.productionCountries = response.productionCountries.map(ProductionCountry.init)
        self.releaseDate = response.releaseDate
        self.revenue = response.revenue
        self.runtime = response.runtime
        self.spokenLanguages = response.spokenLanguages.map(SpokenLanguage.init)
        self.status = response.status
        self.tagline = response.tagline
        self.title = response.title
        self.video = response.video
        self.voteAverage = response.voteAverage
        self.voteCount = response.voteCount
    }
}


struct BelongsToCollection: Codable, Hashable {
    let id: Int?
    let name: String?
    let posterPath: String?
    let backdropPath: String?
}

extension BelongsToCollection {
    nonisolated init(from response: APIBelongsToCollection) {
        self.id = response.id
        self.name = response.name
        self.posterPath = response.posterPath
        self.backdropPath = response.backdropPath
    }
}


struct Genre: Codable, Hashable {
    let id: Int
    let name: String
}

extension Genre {
    nonisolated init(from response: APIGenre) {
        self.id = response.id
        self.name = response.name
    }
}

struct SpokenLanguage: Codable, Hashable {
    let englishName: String
    let iso_639_1: String
    let name: String
}

extension SpokenLanguage {
    nonisolated init(from response: APISpokenLanguage) {
        self.englishName = response.englishName
        self.iso_639_1 = response.iso_639_1
        self.name = response.name
    }
}

struct ProductionCompany: Codable, Hashable {
    let id: Int?
    let logoPath: String?
    let name: String?
    let originCountry: String?
}
extension ProductionCompany {
    nonisolated init(from response: APIProductionCompany) {
        self.id = response.id
        self.logoPath = response.logoPath
        self.name = response.name
        self.originCountry = response.originCountry
    }
}

struct ProductionCountry: Codable, Hashable {
    let iso_3166_1: String?
    let name: String?
    
}
extension ProductionCountry {
    nonisolated init(from response: APIProductionCountry) {
        self.iso_3166_1 = response.iso_3166_1
        self.name = response.name
    }
}
