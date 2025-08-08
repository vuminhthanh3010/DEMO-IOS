import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Initialize window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create initial view controller
        let splashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashViewController)
        
        // Configure navigation controller
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        // Set root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        // Initialize default settings
        setupDefaultSettings()
        
        return true
    }
    
    // MARK: - Default Settings
    private func setupDefaultSettings() {
        let defaults = UserDefaults.standard
        
        // Set default values if not already set
        if defaults.object(forKey: "isDarkMode") == nil {
            defaults.set(false, forKey: "isDarkMode")
        }
        
        if defaults.object(forKey: "soundEnabled") == nil {
            defaults.set(true, forKey: "soundEnabled")
        }
        
        if defaults.object(forKey: "hapticEnabled") == nil {
            defaults.set(true, forKey: "hapticEnabled")
        }
        
        if defaults.object(forKey: "playerName") == nil {
            defaults.set("Pulse Master", forKey: "playerName")
        }
        
        // Initialize game statistics
        if defaults.object(forKey: "totalScore") == nil {
            defaults.set(0, forKey: "totalScore")
        }
        
        if defaults.object(forKey: "gamesPlayed") == nil {
            defaults.set(0, forKey: "gamesPlayed")
        }
    }
    
    // MARK: UISceneSession Lifecycle (iOS 13+)
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session
    }
}

// MARK: - Scene Delegate (iOS 13+)
@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Initialize window
        window = UIWindow(windowScene: windowScene)
        
        // Create initial view controller
        let splashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashViewController)
        
        // Configure navigation controller
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        
        // Set root view controller
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background
    }
}