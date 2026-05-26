import Foundation
import RIBs

protocol SearchResultInteractable: Interactable, SearchResultPresentableListener {
    var router: SearchResultRouting? { get set }
    var listener: SearchResultListener? { get set }
}

protocol SearchResultViewControllable: ViewControllable {
    func presentWebView(url: URL)
}

final nonisolated class SearchResultRouter: ViewableRouter<SearchResultInteractable, SearchResultViewControllable>, SearchResultRouting {

    override nonisolated init(interactor: SearchResultInteractable, viewController: SearchResultViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
    }
}

// MARK: - SearchResultRouting
extension SearchResultRouter {
    func routeToWeb(url: URL) {
        viewController.presentWebView(url: url)
    }
}
