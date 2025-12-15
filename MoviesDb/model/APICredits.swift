struct APICredits: Codable {
    let id: Int
    let cast: [APICastMember]
}

struct APICastMember: Codable, Identifiable {
    let adult: Bool?
    let gender: Int?
    let id: Int
    let knownForDepartment: String?
    let name: String?
    let originalName: String?
    let popularity: Float?
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id, name, popularity, character, order
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castId = "cast_id"
        case creditId = "credit_id"
    }
}
