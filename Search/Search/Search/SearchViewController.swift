import RIBs
import RxSwift
import UIKit

protocol SearchPresentableListener: AnyObject {
    // TODO: ViewController -> Interactor 비즈니스 로직 호출 메서드 선언
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?
}
