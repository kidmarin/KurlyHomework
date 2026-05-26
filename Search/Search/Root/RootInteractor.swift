import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func routeToSearch()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject { }

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override nonisolated init(presenter: RootPresentable) {
        super.init(presenter: presenter)
    }
}

// MARK: - RootPresentableListener
extension RootInteractor: RootPresentableListener {
    func viewDidLoad() {
        router?.routeToSearch()
    }
}

// MARK: - SearchListener
extension RootInteractor: SearchListener { }
