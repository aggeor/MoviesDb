import Foundation

struct MovieDataWrapper: Decodable {
    let page: Int?
    let results: [Movie]
    let total_pages: Int
    let total_results: Int?
}

struct Movie: Hashable, Codable{
    let adult: Bool?
    let backdrop_path: String?
    let genre_ids: [Int]?
    let id: Int
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Float?
    let poster_path: String?
    let release_date: String?
    let title: String?
    let video: Bool?
    let vote_average: Float?
    let vote_count: Int?
}
