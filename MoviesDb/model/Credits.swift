struct Credits: Codable {
    let id: Int
    let cast: [CastMember]
}

struct CastMember: Codable, Identifiable {
    let adult: Bool?
    let gender: Int?
    let id: Int
    let known_for_department: String?
    let name: String?
    let original_name: String?
    let popularity: Float?
    let profile_path: String?
    let cast_id: Int?
    let character: String?
    let credit_id: String?
    let order: Int?
}
