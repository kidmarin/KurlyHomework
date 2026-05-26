import Alamofire
import Foundation

protocol SearchResultRepositoryProtocol {

    var keyword: String { get async }

    func search(keyword: String) async throws -> SearchResultResponse
    func loadNextPage() async throws -> SearchResultResponse?
}

actor SearchResultRepository: SearchResultRepositoryProtocol {

    var keyword: String = ""
    private var page: Int = 0
    private var totalCount: Int = 0
    private var accumulatedItems: [SearchResultItem] = []
    private var currentRequest: DataRequest?

    func search(keyword: String) async throws -> SearchResultResponse {
        currentRequest?.cancel()
        self.keyword = keyword

        let response = try await fetch(keyword: keyword, page: 1)
        accumulatedItems = response.items
        totalCount = response.totalCount
        page = 1
        return SearchResultResponse(totalCount: totalCount, items: accumulatedItems)
    }

    func loadNextPage() async throws -> SearchResultResponse? {
        guard accumulatedItems.count < totalCount else { return nil }
        currentRequest?.cancel()

        let response = try await fetch(keyword: keyword, page: page + 1)
        accumulatedItems.append(contentsOf: response.items)
        totalCount = response.totalCount
        page += 1
        return SearchResultResponse(totalCount: totalCount, items: accumulatedItems)
    }
}

// MARK: - Private
extension SearchResultRepository {

    private func fetch(keyword: String, page: Int) async throws -> SearchResultResponse {
        let request = AF.request(
            Const.searchURL,
            method: .get,
            parameters: ["q": keyword, "page": page]
        )
        currentRequest = request
        return try await withCheckedThrowingContinuation { continuation in
            request.responseDecodable(of: SearchResultResponse.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Const
extension SearchResultRepository {

    enum Const {

        static let searchURL = "https://api.github.com/search/repositories"
    }
}
