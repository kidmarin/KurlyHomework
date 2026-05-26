import RIBs
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var router: ViewableRouting?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let router = RootBuilder(dependency: AppComponent()).build(withListener: AppRootListener())
        self.router = router

        window.rootViewController = router.viewControllable.uiviewController
        window.makeKeyAndVisible()

        router.interactable.activate()
        router.load()
    }
}

// MARK: - AppRootListener
private final class AppRootListener: RootListener { }
