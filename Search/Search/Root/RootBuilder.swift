import UIKit
import RIBs

protocol RootDependency: Dependency {
}

final class RootComponent: Component<RootDependency>, SearchDependency {

    override nonisolated init(dependency: any RootDependency) {
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol RootBuildable: Buildable {
    func build(withListener listener: RootListener) -> RootRouting
}

final class RootBuilder: Builder<RootDependency>, RootBuildable {

    override nonisolated init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RootListener) -> RootRouting {
        let component = RootComponent(dependency: dependency)
        let viewController = RootViewController()
        let interactor = RootInteractor(presenter: viewController)
        interactor.listener = listener
        viewController.listener = interactor
        let searchBuilder = SearchBuilder(dependency: component)
        let router = RootRouter(
            interactor: interactor,
            viewController: viewController,
            searchBuilder: searchBuilder
        )
        interactor.router = router

        return router
    }
}
