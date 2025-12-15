struct Credits {
    let id: Int
    let cast: [CastMember]
}

struct CastMember: Identifiable, Hashable, Sendable {
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
}


extension Credits {
    init(from response: APICredits) {
        self.id = response.id
        self.cast = response.cast.map(CastMember.init)
    }
}


extension CastMember {
    nonisolated init(from response: APICastMember) {
        self.adult = response.adult
        self.gender = response.gender
        self.id = response.id
        self.knownForDepartment = response.knownForDepartment
        self.name = response.name
        self.originalName = response.originalName
        self.popularity = response.popularity
        self.profilePath = response.profilePath
        self.castId = response.castId
        self.character = response.character
        self.creditId = response.creditId
        self.order = response.order
    }
}
