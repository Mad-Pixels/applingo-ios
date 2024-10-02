import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinatorProtocol!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Инициализация AppCoordinator
        appCoordinator = AppCoordinator()
        appCoordinator.start()
        
        // Настройка окна и корневого view controller
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UIViewController() // Замените на ваш начальный view controller
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // Добавьте остальные методы UIApplicationDelegate по необходимости
}
