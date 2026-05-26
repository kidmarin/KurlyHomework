import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    // TODO: Interactor -> Router 호출 메서드 선언
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    // TODO: Interactor -> ViewController 데이터 전달 메서드 선언
}

protocol RootListener: AnyObject {
    // TODO: 부모 RIB과의 통신 메서드 선언
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?

    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
