
import UIKit
import RealmSwift


@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    //Target is to create a new project
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        let mainViewController = PokemonListWireframe.createPokemonListModule()
        let navController = UINavigationController(rootViewController: mainViewController)
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        return true
    }
}

