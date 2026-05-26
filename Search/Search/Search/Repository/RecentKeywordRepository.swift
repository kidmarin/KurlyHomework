import Foundation

protocol RecentKeywordRepositoryProtocol {

    func fetch() async -> [RecentKeyword]
    func save(_ keyword: String) async
    func delete(_ keyword: String) async
    func deleteAll() async
}

actor RecentKeywordRepository: RecentKeywordRepositoryProtocol {

    func fetch() -> [RecentKeyword] {
        guard let data = UserDefaults.standard.data(forKey: Const.key),
              let keywords = try? JSONDecoder().decode([RecentKeyword].self, from: data) else {
            return []
        }
        return keywords
    }

    func save(_ keyword: String) {
        var keywords = fetch()
        keywords.removeAll { $0.keyword.caseInsensitiveCompare(keyword) == .orderedSame }
        keywords.insert(RecentKeyword(keyword: keyword, date: Date()), at: 0)
        encode(Array(keywords.prefix(Const.limit)))
    }

    func delete(_ keyword: String) {
        var keywords = fetch()
        keywords.removeAll { $0.keyword == keyword }
        encode(keywords)
    }

    func deleteAll() {
        encode([])
    }
}

// MARK: - Private
extension RecentKeywordRepository {

    private func encode(_ keywords: [RecentKeyword]) {
        guard let data = try? JSONEncoder().encode(keywords) else { return }
        UserDefaults.standard.set(data, forKey: Const.key)
    }
}

// MARK: - Const
extension RecentKeywordRepository {

    enum Const {

        static let key = "recent_keywords"
        static let limit = 10
    }
}
