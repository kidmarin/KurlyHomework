import UIKit
import RIBs

protocol SearchDependency: Dependency {
}

final nonisolated class SearchComponent: Component<SearchDependency>, SearchResultDependency {

    private let viewController: SearchViewController

    init(dependency: SearchDependency, viewController: SearchViewController) {
        self.viewController = viewController
        super.init(dependency: dependency)
    }

    var searchViewController: SearchViewController {
        viewController
    }

    var searchResultRepository: SearchResultRepositoryProtocol {
        shared { SearchResultRepository() }
    }

    var recentKeywordRepository: RecentKeywordRepositoryProtocol {
        shared { RecentKeywordRepository() }
    }
}

// MARK: - Builder

protocol SearchBuildable: Buildable {
    func build(withListener listener: SearchListener) -> SearchRouting
}

final class SearchBuilder: Builder<SearchDependency>, SearchBuildable {

    override nonisolated init(dependency: SearchDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SearchListener) -> SearchRouting {
        let viewController = SearchViewController()
        let component = SearchComponent(dependency: dependency, viewController: viewController)
        let interactor = SearchInteractor(
            presenter: viewController,
            repository: component.recentKeywordRepository
        )
        interactor.listener = listener
        viewController.searchListener = interactor
        let searchResultBuilder = SearchResultBuilder(dependency: component)
        let router = SearchRouter(
            interactor: interactor,
            viewController: viewController,
            searchResultBuilder: searchResultBuilder
        )
        interactor.router = router

        return router
    }
}
