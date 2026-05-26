import RIBs
import RxSwift
import UIKit

protocol SearchRouting: ViewableRouting {
    func attachSearchResult()
    func detachSearchResult()
}

protocol SearchPresentable: Presentable {
    var searchListener: SearchPresentableListener? { get set }
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<SearchInteractor.SearchSection, SearchInteractor.SearchItem>)
}

protocol SearchListener: AnyObject {
}

final nonisolated class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable {

    weak var router: SearchRouting?
    weak var listener: SearchListener?

    private let repository: RecentKeywordRepositoryProtocol

    nonisolated init(presenter: SearchPresentable, repository: RecentKeywordRepositoryProtocol) {
        self.repository = repository
        super.init(presenter: presenter)
    }
}

// MARK: - DataSource
extension SearchInteractor {
    nonisolated enum SearchSection: Hashable, Sendable {
        case recentKeyword
        case filteredRecentKeyword
        case searchResult
    }

    nonisolated enum SearchItem: Hashable {
        case recentKeyword(RecentKeyword)
        case filteredRecentKeyword(String)
        case searchResult(SearchResultItem)
    }
}

// MARK: - Private
extension SearchInteractor {
    private func fetchRecentKeywords() {
        Task {
            let keywords = await repository.fetch()
            var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
            if !keywords.isEmpty {
                snapshot.appendSections([.recentKeyword])
                snapshot.appendItems(keywords.map { .recentKeyword($0) }, toSection: .recentKeyword)
            }
            presenter.applySnapshot(snapshot)
        }
    }
}

// MARK: - SearchResultListener
extension SearchInteractor: SearchResultListener {
    func didSearch() {
        fetchRecentKeywords()
    }
}

// MARK: - SearchPresentableListener
extension SearchInteractor: SearchPresentableListener {
    func viewDidLoad() {
        fetchRecentKeywords()
    }

    func deleteRecentKeyword(_ keyword: String) {
        Task {
            await repository.delete(keyword)
            fetchRecentKeywords()
        }
    }

    func deleteAllRecentKeywords() {
        Task {
            await repository.deleteAll()
            fetchRecentKeywords()
        }
    }
}
