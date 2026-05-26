import RIBs

protocol SearchResultInteractable: Interactable, SearchResultPresentableListener {
    var router: SearchResultRouting? { get set }
    var listener: SearchResultListener? { get set }
}

protocol SearchResultViewControllable: ViewControllable {
}

final nonisolated class SearchResultRouter: ViewableRouter<SearchResultInteractable, SearchResultViewControllable>, SearchResultRouting {

    override nonisolated init(interactor: SearchResultInteractable, viewController: SearchResultViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
    }
}
