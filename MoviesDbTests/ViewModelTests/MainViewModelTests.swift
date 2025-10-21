import XCTest
@testable import MoviesDb

final class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockSession: URLSession!
    
    override func setUp() async throws{
        try await super.setUp()
        
        // Create mock URL protocol configuration
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            let data = Self.sampleMoviesJSON.data(using: .utf8)!
            return (response, data)
        }
        mockSession = URLSession(configuration: config)
        
        // Inject mock session into view model
        viewModel = await MainViewModel(session: mockSession)
    }
    
    override func tearDown() {
        viewModel = nil
        mockSession = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }
    
    @MainActor
    func testSearchSetsCorrectTitle() async {
        
        // When
        await viewModel.search("Batman")
        
        // Then
        XCTAssertEqual(viewModel.title, "Search results for: Batman")
        XCTAssertFalse(viewModel.movies.isEmpty)
        XCTAssertTrue(viewModel.movies.contains { $0.title == "Batman Begins" })
    }
    
    @MainActor
    func testPopularMoviesSearchSetsDefaultTitle() async {
        
        // When
        await viewModel.search(nil)
        
        // Then
        XCTAssertEqual(viewModel.title, "Popular Movies")
        XCTAssertEqual(viewModel.movies.count, 1)
    }
    
    @MainActor
    func testFetchNextIfNeededLoadsNextPage() async {
        
        // When
        await viewModel.search(nil)
        let firstMovie = viewModel.movies.first!
        
        await viewModel.fetchNextIfNeeded(currentMovie: firstMovie)
        // Then
        XCTAssertFalse(viewModel.movies.isEmpty)
    }
    
    @MainActor
    func testInvalidQueryDoesNotCrash() async {
        // Inject bad query to trigger invalid URL
        await viewModel.search("fdabkfkdabfa")
        // Just ensure no crash
        XCTAssertNotNil(viewModel)
    }
    
    @MainActor
    func testEmptySearchResults() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let emptyJSON = """
            { "page": 1, "results": [], "total_pages": 1 }
            """
            let data = emptyJSON.data(using: .utf8)!
            return (response, data)
        }
        
        await viewModel.search("UnknownMovie")
        
        XCTAssertEqual(viewModel.title, "Search results for: UnknownMovie")
        XCTAssertTrue(viewModel.movies.isEmpty)
    }
    
    @MainActor
    func testPaginationAppendsMovies() async {
        var callCount = 0
        MockURLProtocol.requestHandler = { request in
            callCount += 1
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let pageJSON = """
            { 
              "page": \(callCount), 
              "results": [
                { "id": \(callCount), "title": "Movie \(callCount)", "poster_path": "/test.jpg" }
              ],
              "total_pages": 2
            }
            """
            let data = pageJSON.data(using: .utf8)!
            return (response, data)
        }
        
        await viewModel.search(nil)
        XCTAssertEqual(viewModel.movies.count, 1)
        
        let firstMovie = viewModel.movies.first!
        await viewModel.fetchNextIfNeeded(currentMovie: firstMovie)
        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertTrue(viewModel.movies.contains { $0.title == "Movie 2" })
    }
    
    @MainActor
    func testFiltersMoviesWithoutTitleOrPoster() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            let json = """
            {
              "page": 1,
              "results": [
                { "id": 1, "title": "Valid Movie", "poster_path": "/test.jpg" },
                { "id": 2, "title": null, "poster_path": "/test.jpg" },
                { "id": 3, "title": "NoPoster", "poster_path": null }
              ],
              "total_pages": 1
            }
            """
            let data = json.data(using: .utf8)!
            return (response, data)
        }
        
        await viewModel.search(nil)
        
        XCTAssertEqual(viewModel.movies.count, 1)
        XCTAssertEqual(viewModel.movies.first?.title, "Valid Movie")
    }
    
    @MainActor
    func testServerErrorDoesNotCrashAndResetsLoading() async {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500, // simulate server error
                httpVersion: nil,
                headerFields: nil
            )!
            let data = Data() // empty data
            return (response, data)
        }
    

        await viewModel.search("Batman")

        // Even if server fails, the app should not crash
        XCTAssertNotNil(viewModel)
        // Movies should remain empty
        XCTAssertTrue(viewModel.movies.isEmpty)
        // isLoading should have reset to false
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor
    func testNetworkErrorDoesNotCrashAndResetsLoading() async {
        // Arrange
        MockURLProtocol.requestHandler = { request in
            // Simulate a network error
            throw URLError(.notConnectedToInternet)
        }

        // Act
        await viewModel.search("Batman")

        // Assert
        XCTAssertNotNil(viewModel)
        XCTAssertTrue(viewModel.movies.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.title, "Search results for: Batman")
    }


}

extension MainViewModelTests {
    static let sampleMoviesJSON = """
    {
      "page": 1,
      "results": [
        {
          "id": 1,
          "title": "Batman Begins",
          "poster_path": "/test.jpg"
        }
      ],
      "total_pages": 1
    }
    """
}
