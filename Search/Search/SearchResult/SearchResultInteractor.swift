import RIBs
import RxSwift
import UIKit

protocol SearchResultRouting: ViewableRouting {

    func routeToWeb(url: URL)
}

protocol SearchResultPresentable: Presentable {

    var searchResultListener: SearchResultPresentableListener? { get set }
    func applySnapshot(_ snapshot: NSDiffableDataSourceSnapshot<SearchInteractor.SearchSection, SearchInteractor.SearchItem>)
    func showLoading()
    func hideLoading()
}

protocol SearchResultListener: AnyObject { }

final nonisolated class SearchResultInteractor: PresentableInteractor<SearchResultPresentable>, SearchResultInteractable {

    weak var router: SearchResultRouting?
    weak var listener: SearchResultListener?

    private let searchResultRepository: SearchResultRepositoryProtocol
    private let recentKeywordRepository: RecentKeywordRepositoryProtocol

    nonisolated init(
        presenter: SearchResultPresentable,
        searchResultRepository: SearchResultRepositoryProtocol,
        recentKeywordRepository: RecentKeywordRepositoryProtocol
    ) {
        self.searchResultRepository = searchResultRepository
        self.recentKeywordRepository = recentKeywordRepository
        super.init(presenter: presenter)
    }
}

// MARK: - SearchResultPresentableListener
extension SearchResultInteractor: SearchResultPresentableListener {

    func didSelectItem(_ item: SearchResultItem) {
        guard let url = URL(string: item.htmlURL) else { return }
        router?.routeToWeb(url: url)
    }

    func search(with keyword: String) {
        Task {
            await recentKeywordRepository.save(keyword)
            presenter.showLoading()
            do {
                let response = try await searchResultRepository.search(keyword: keyword)
                var snapshot = NSDiffableDataSourceSnapshot<SearchInteractor.SearchSection, SearchInteractor.SearchItem>()
                snapshot.appendSections([.searchResult])
                snapshot.appendItems(response.items.map { .searchResult($0) }, toSection: .searchResult)
                presenter.applySnapshot(snapshot)
            } catch {
                // TODO: 에러 처리
            }
            presenter.hideLoading()
        }
    }
}
