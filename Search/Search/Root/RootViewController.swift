import RIBs
import UIKit

protocol RootPresentableListener: AnyObject {
    // TODO: ViewController -> Interactor 비즈니스 로직 호출 메서드 선언
}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
    }
}
