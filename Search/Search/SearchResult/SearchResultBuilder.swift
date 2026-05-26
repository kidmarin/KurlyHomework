import RIBs

protocol SearchResultDependency: Dependency {
    var searchViewController: SearchViewController { get }
    var searchResultRepository: SearchResultRepositoryProtocol { get }
    var recentKeywordRepository: RecentKeywordRepositoryProtocol { get }
}

final class SearchResultComponent: Component<SearchResultDependency> {

    nonisolated override init(dependency: SearchResultDependency) {
        super.init(dependency: dependency)
    }

    fileprivate var searchViewController: SearchViewController {
        dependency.searchViewController
    }

    fileprivate var searchResultRepository: SearchResultRepositoryProtocol {
        dependency.searchResultRepository
    }

    fileprivate var recentKeywordRepository: RecentKeywordRepositoryProtocol {
        dependency.recentKeywordRepository
    }
}

// MARK: - Builder

protocol SearchResultBuildable: Buildable {
    func build(withListener listener: SearchResultListener) -> SearchResultRouting
}

final class SearchResultBuilder: Builder<SearchResultDependency>, SearchResultBuildable {

    override nonisolated init(dependency: SearchResultDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchResultListener) -> SearchResultRouting {
        let component = SearchResultComponent(dependency: dependency)
        let viewController = component.searchViewController
        let interactor = SearchResultInteractor(
            presenter: viewController,
            searchResultRepository: component.searchResultRepository,
            recentKeywordRepository: component.recentKeywordRepository
        )
        interactor.listener = listener
        viewController.searchResultListener = interactor
        let router = SearchResultRouter(interactor: interactor, viewController: viewController)
        interactor.router = router

        return router
    }
}
