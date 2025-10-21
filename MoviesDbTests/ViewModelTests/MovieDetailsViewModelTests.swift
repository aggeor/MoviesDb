import XCTest
@testable import MoviesDb

final class MovieDetailViewModelTests: XCTestCase {
    var viewModel: MovieDetailViewModel!
    var mockSession: URLSession!

    override func setUp() async throws {
        try await super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        mockSession = URLSession(configuration: config)
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = MovieDetailViewModelTests.MovieDetailSampleJSON.data(using: .utf8)!
            return (response, data)
        }
        viewModel = await MovieDetailViewModel(session: mockSession)
    }

    override func tearDown() {
        viewModel = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    @MainActor
    func testFetchDetailsSuccess() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = MovieDetailViewModelTests.MovieDetailSampleJSON.data(using: .utf8)!
            return (response, data)
        }

        await viewModel.fetchDetails(for: 1)

        XCTAssertFalse(viewModel.isLoadingDetails)
        XCTAssertEqual(viewModel.movieDetail?.title, "Batman Begins")
        XCTAssertEqual(viewModel.movieDetail?.genres.first?.name, "Action")
    }

    @MainActor
    func testFetchCreditsSuccess() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let data = MovieDetailViewModelTests.CreditsSampleJSON.data(using: .utf8)!
            return (response, data)
        }

        await viewModel.fetchCredits(for: 1)

        XCTAssertFalse(viewModel.isLoadingCredits)
        XCTAssertEqual(viewModel.cast.count, 1)
        XCTAssertEqual(viewModel.cast.first?.name, "Christian Bale")
    }

    @MainActor
    func testFetchDetailsInvalidURLDoesNotCrash() async {
        MockURLProtocol.requestHandler = { request in
            throw URLError(.badURL)
        }
        await viewModel.fetchDetails(for: -999)
        XCTAssertNil(viewModel.movieDetail)
    }

    @MainActor
    func testFetchCreditsInvalidURLDoesNotCrash() async {
        MockURLProtocol.requestHandler = { request in
            throw URLError(.badURL)
        }
        await viewModel.fetchCredits(for: -1)
        XCTAssertTrue(viewModel.cast.isEmpty)
    }
    
    @MainActor
    func testFetchDetailsWithPartialData() async {
        MockURLProtocol.requestHandler = { request in
            let json = """
            { "id": 2, "title": "Unknown title", "genres": [] }
            """
            let data = json.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        await viewModel.fetchDetails(for: 2)
        XCTAssertEqual(viewModel.movieDetail, nil)
    }
    
    @MainActor
    func testFetchDetailsServerError() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }

        await viewModel.fetchDetails(for: 1)
        XCTAssertNil(viewModel.movieDetail)
    }
    
    @MainActor
    func testFetchDetailsMalformedJSON() async {
        MockURLProtocol.requestHandler = { request in
            let data = "invalid json".data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        await viewModel.fetchDetails(for: 1)
        XCTAssertNil(viewModel.movieDetail)
    }
    
    @MainActor
    func testFetchCreditsEmptyCast() async {
        MockURLProtocol.requestHandler = { request in
            let json = """
            { "id": 1, "cast": [] }
            """
            let data = json.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        await viewModel.fetchCredits(for: 1)
        XCTAssertTrue(viewModel.cast.isEmpty)
    }


}

extension MovieDetailViewModelTests {
    static let MovieDetailSampleJSON = """
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
        "belongs_to_collection": null,
        "production_companies": [],
        "production_countries": [],
        "spoken_languages": []
    }
    """

    static let CreditsSampleJSON = """
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
}
