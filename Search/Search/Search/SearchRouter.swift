import RIBs

protocol SearchInteractable: Interactable, SearchResultListener {
    var router: SearchRouting? { get set }
    var listener: SearchListener? { get set }
}

protocol SearchViewControllable: ViewControllable {
    var searchResultListener: SearchResultPresentableListener? { get set }
}

final nonisolated class SearchRouter: ViewableRouter<SearchInteractable, SearchViewControllable>, SearchRouting {

    private let searchResultBuilder: SearchResultBuildable

    nonisolated init(
        interactor: SearchInteractable,
        viewController: SearchViewControllable,
        searchResultBuilder: SearchResultBuildable
    ) {
        self.searchResultBuilder = searchResultBuilder
        super.init(interactor: interactor, viewController: viewController)
    }

    override func didLoad() {
        super.didLoad()
        Task { @MainActor in
            attachSearchResult()
        }
    }
}

// MARK: - SearchRouting
extension SearchRouter {
    func attachSearchResult() {
        let router = searchResultBuilder.build(withListener: interactor)
        attachChild(router)
    }

    func detachSearchResult() {
        guard let router = children.first(where: { $0 is SearchResultRouter }) as? SearchResultRouter else { return }
        viewController.searchResultListener = nil
        detachChild(router)
    }
}
