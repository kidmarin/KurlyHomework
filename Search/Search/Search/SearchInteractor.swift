import RIBs
import RxSwift

protocol SearchRouting: ViewableRouting {
    // TODO: Interactor -> Router 호출 메서드 선언
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    // TODO: Interactor -> ViewController 데이터 전달 메서드 선언
}

protocol SearchListener: AnyObject {
    // TODO: 부모 RIB과의 통신 메서드 선언
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {

    weak var router: SearchRouting?
    weak var listener: SearchListener?

    override nonisolated init(presenter: SearchPresentable) {
        super.init(presenter: presenter)
    }
}
