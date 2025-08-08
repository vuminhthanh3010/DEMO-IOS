import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let splashVC = SplashViewController()
        let nav = UINavigationController(rootViewController: splashVC)
        nav.navigationBar.prefersLargeTitles = false
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}