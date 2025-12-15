import XCTest
@testable import MoviesDb

final class MovieModelsTests: XCTestCase {
    
    @MainActor
    func testMovieDecoding() throws {
        let json = """
        {
            "id": 1,
            "title": "Batman Begins",
            "poster_path": "/poster.jpg"
        }
        """
        let data = json.data(using: .utf8)!
        let movie = try JSONDecoder().decode(APIMovie.self, from: data)
        
        XCTAssertEqual(movie.id, 1)
        XCTAssertEqual(movie.title, "Batman Begins")
        XCTAssertEqual(movie.posterPath, "/poster.jpg")
    }

    @MainActor
    func testMovieDataWrapperDecoding() throws {
        let json = """
        {
            "page": 1,
            "results": [
                {
                    "id": 1,
                    "title": "Batman Begins",
                    "poster_path": "/poster.jpg"
                },
                {
                    "id": 2,
                    "title": "The Dark Knight",
                    "poster_path": "/darkknight.jpg"
                }
            ],
            "total_pages": 5
        }
        """
        let data = json.data(using: .utf8)!
        let wrapper = try JSONDecoder().decode(APIMovies.self, from: data)
        
        XCTAssertEqual(wrapper.page, 1)
        XCTAssertEqual(wrapper.totalPages, 5)
        XCTAssertEqual(wrapper.results.count, 2)
        XCTAssertEqual(wrapper.results[0].title, "Batman Begins")
        XCTAssertEqual(wrapper.results[1].posterPath, "/darkknight.jpg")
    }

    @MainActor
    func testMovieDetailsDecoding() throws {
        let json = """
        {
            "id": 1,
            "title": "Batman Begins",
            "backdrop_path": "/backdrop.jpg",
            "poster_path": "/poster.jpg",
            "genres": [{"id": 1, "name": "Action"}],
            "release_date": "2005-06-15",
            "runtime": 140,
            "vote_average": 8.2,
            "vote_count": 1500,
            "status": "Released",
            "overview": "A young Bruce Wayne...",
            "belongs_to_collection": {"id": 10, "name": "Batman Collection", "poster_path": "/collection.jpg", "backdrop_path": "/collection_bg.jpg"},
            "production_companies": [{"id": 100, "logo_path": "/logo.png", "name": "Warner Bros", "origin_country": "US"}],
            "production_countries": [{"iso_3166_1": "US", "name": "United States"}],
            "spoken_languages": [{"english_name": "English", "iso_639_1": "en", "name": "English"}]
        }
        """
        let data = json.data(using: .utf8)!
        let movie = try JSONDecoder().decode(APIMovieDetails.self, from: data)
        
        XCTAssertEqual(movie.id, 1)
        XCTAssertEqual(movie.title, "Batman Begins")
        XCTAssertEqual(movie.genres.first?.name, "Action")
        XCTAssertEqual(movie.releaseDate, "2005-06-15")
        XCTAssertEqual(movie.runtime, 140)
        XCTAssertEqual(movie.voteAverage, 8.2)
        XCTAssertEqual(movie.voteCount, 1500)
        XCTAssertEqual(movie.status, "Released")
        XCTAssertEqual(movie.overview, "A young Bruce Wayne...")
        XCTAssertEqual(movie.belongsToCollection?.name, "Batman Collection")
        XCTAssertEqual(movie.productionCompanies.first?.name, "Warner Bros")
        XCTAssertEqual(movie.productionCountries.first?.name, "United States")
        XCTAssertEqual(movie.spokenLanguages.first?.englishName, "English")
    }

    @MainActor
    func testCreditsDecoding() throws {
        let json = """
        {
            "id": 1,
            "cast": [
                {
                    "id": 100,
                    "name": "Christian Bale",
                    "character": "Bruce Wayne",
                    "profile_path": "/bale.jpg"
                }
            ]
        }
        """
        let data = json.data(using: .utf8)!
        let credits = try JSONDecoder().decode(APICredits.self, from: data)
        
        XCTAssertEqual(credits.id, 1)
        XCTAssertEqual(credits.cast.count, 1)
        XCTAssertEqual(credits.cast.first?.name, "Christian Bale")
        XCTAssertEqual(credits.cast.first?.character, "Bruce Wayne")
    }

    @MainActor
    func testCastMemberDecoding() throws {
        let json = """
        {
            "id": 100,
            "name": "Christian Bale",
            "character": "Bruce Wayne",
            "profile_path": "/bale.jpg"
        }
        """
        let data = json.data(using: .utf8)!
        let cast = try JSONDecoder().decode(APICastMember.self, from: data)
        
        XCTAssertEqual(cast.id, 100)
        XCTAssertEqual(cast.name, "Christian Bale")
        XCTAssertEqual(cast.character, "Bruce Wayne")
        XCTAssertEqual(cast.profilePath, "/bale.jpg")
    }

    @MainActor
    func testGenreDecoding() throws {
        let json = """
        {"id": 1, "name": "Action"}
        """
        let data = json.data(using: .utf8)!
        let genre = try JSONDecoder().decode(Genre.self, from: data)
        
        XCTAssertEqual(genre.id, 1)
        XCTAssertEqual(genre.name, "Action")
    }

    @MainActor
    func testFormatDateHelper() {
        let dateString = "2025-10-21"
        let formatted = formatDate(dateString)
        XCTAssertEqual(formatted, "October 21, 2025")
        
        let invalidDate = "not-a-date"
        XCTAssertEqual(formatDate(invalidDate), "not-a-date")
    }
}
