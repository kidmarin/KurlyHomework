import Alamofire
import Foundation

protocol SearchResultRepositoryProtocol {
    func search(keyword: String) async throws -> SearchResultResponse
}

actor SearchResultRepository: SearchResultRepositoryProtocol {

    func search(keyword: String) async throws -> SearchResultResponse {
        let parameters: Parameters = ["q": keyword]
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(Const.searchURL, method: .get, parameters: parameters)
                .responseDecodable(of: SearchResultResponse.self) { response in
                    switch response.result {
                    case .success(let searchResultResponse):
                        continuation.resume(returning: searchResultResponse)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}

// MARK: - Constants
extension SearchResultRepository {
    enum Const {
        static let searchURL = "https://api.github.com/search/repositories"
    }
}
