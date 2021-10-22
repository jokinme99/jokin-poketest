
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success , _ in
//            guard success else {return}
//            application.registerForRemoteNotifications()
//            print("Success in APN registry")
//        }
        IQKeyboardManager.shared.enable = true
        
        setWindow()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //completionHandler([.sound, .badge, .alert]) what will show(sound yes or no badge or alert) 
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else{return}
            print("Token: \(token)")
        }
    }
    
    func setWindow(){
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        let mainViewController = PokemonListWireframe.createPokemonListModule()
        let navController = UINavigationController(rootViewController: mainViewController)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    
    
}

