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

protocol SearchListener: AnyObject { }

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
        case filteredRecentKeyword(RecentKeyword)
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

    private func applyFilteredKeywordsSnapshot(text: String) {
        Task {
            let keywords = await repository.fetch()
            let filtered = keywords.filter { $0.keyword.localizedCaseInsensitiveContains(text) }
            var snapshot = NSDiffableDataSourceSnapshot<SearchSection, SearchItem>()
            if !filtered.isEmpty {
                snapshot.appendSections([.filteredRecentKeyword])
                snapshot.appendItems(filtered.map { .filteredRecentKeyword($0) }, toSection: .filteredRecentKeyword)
            }
            presenter.applySnapshot(snapshot)
        }
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

    func filterRecentKeywords(with text: String) {
        if text.isEmpty {
            fetchRecentKeywords()
        } else {
            applyFilteredKeywordsSnapshot(text: text)
        }
    }
}
