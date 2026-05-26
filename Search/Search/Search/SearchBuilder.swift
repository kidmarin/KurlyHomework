import UIKit
import RIBs

protocol SearchDependency: Dependency {
}

final class SearchComponent: Component<SearchDependency> {

    nonisolated override init(dependency: any SearchDependency) {
        super.init(dependency: dependency)
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
        let component = SearchComponent(dependency: dependency)
        let viewController = SearchViewController()
        let interactor = SearchInteractor(presenter: viewController)
        interactor.listener = listener
        viewController.listener = interactor
        let router = SearchRouter(interactor: interactor, viewController: viewController)
        interactor.router = router

        return router
    }
}
