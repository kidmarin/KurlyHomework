import Foundation

nonisolated struct SearchResultResponse: Decodable, Hashable, Sendable {
    let totalCount: Int
    let items: [SearchResultItem]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

// MARK: Hierarchy Data
nonisolated struct SearchResultItem: Decodable, Hashable, Sendable {
    let id: Int
    let name: String
    let owner: Owner

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case owner
    }
}

nonisolated struct Owner: Decodable, Hashable, Sendable {

    let login: String
    let avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
