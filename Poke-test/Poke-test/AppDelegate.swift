
import UIKit
import RealmSwift

@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    //@available(iOS 13.0, *)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        let mainViewController = PokemonListWireframe.createPokemonListModule()
        let navController = UINavigationController(rootViewController: mainViewController)
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        return true
    }
}

