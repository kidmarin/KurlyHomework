import RIBs

protocol RootInteractable: Interactable {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Router -> ViewController 뷰 계층 조작 메서드 선언
}

final class RootRouter: ViewableRouter<RootInteractable, RootViewControllable>, RootRouting {

    override init(interactor: RootInteractable, viewController: RootViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
