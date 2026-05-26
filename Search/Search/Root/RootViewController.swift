import RIBs
import UIKit

protocol RootPresentableListener: AnyObject {
    func viewDidLoad()
}

final class RootViewController: UINavigationController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
}

// MARK: - Lifecycle
extension RootViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.prefersLargeTitles = true
        listener?.viewDidLoad()
    }
}

// MARK: - RootViewControllable
extension RootViewController {

    func setRootViewController(_ viewControllable: ViewControllable) {
        setViewControllers([viewControllable.uiviewController], animated: false)
    }
}
