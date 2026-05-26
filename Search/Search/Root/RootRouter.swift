import RIBs

protocol RootInteractable: Interactable, SearchListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func setRootViewController(_ viewControllable: ViewControllable)
}

final nonisolated class RootRouter: ViewableRouter<RootInteractable, RootViewControllable>, RootRouting {

    private let searchBuilder: SearchBuildable
    private var searchRouter: ViewableRouting?

    init(
        interactor: RootInteractable,
        viewController: RootViewControllable,
        searchBuilder: SearchBuildable
    ) {
        self.searchBuilder = searchBuilder
        super.init(interactor: interactor, viewController: viewController)
    }
}

// MARK: - RootRouting
extension RootRouter {
    func routeToSearch() {
        let router = searchBuilder.build(withListener: interactor)
        searchRouter = router
        attachChild(router)
        viewController.setRootViewController(router.viewControllable)
    }
}
