
import UIKit
import RealmSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerNotifications()

        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        let mainViewController = PokemonListWireframe.createPokemonListModule()
        let navController = UINavigationController(rootViewController: mainViewController)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        return true
    }
    func registerNotifications(){
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
    }
    func getNotificationSettings() {//If the user declines the permissions
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
      }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        makeNotification(title: "POKEDEX", body: "App has entered in background", timeInterval: 10)
    }
    func makeNotification(title: String, body: String, timeInterval: Double){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

