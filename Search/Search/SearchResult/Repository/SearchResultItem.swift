import Foundation

nonisolated struct SearchResultResponse: Decodable, Hashable, Sendable {

    let totalCount: Int
    let items: [SearchResultItem]

    enum CodingKeys: String, CodingKey {

        case totalCount = "total_count"
        case items
    }
}

nonisolated struct SearchResultItem: Decodable, Hashable, Sendable {

    let id: Int
    let name: String
    let owner: Owner
    let htmlURL: String

    enum CodingKeys: String, CodingKey {

        case id
        case name
        case owner
        case htmlURL = "html_url"
    }
}

nonisolated struct Owner: Decodable, Hashable, Sendable {

    let login: String
    let avatarURL: String

    enum CodingKeys: String, CodingKey {

        case login
        case avatarURL = "avatar_url"
    }
}
