
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseAuth

//MARK: - AppDelegate class
@main
class AppDelegate: UIResponder{
    //Swift package dependencies don't work
    //PIN iPhone: 281106
    var window: UIWindow?
    var state = UIApplication.shared.applicationState
}

//MARK: - UIApplicationDelegate methods
extension AppDelegate: UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success , _ in
            guard success else {return}
            print("Success in APN registry")
            DispatchQueue.main.async { application.registerForRemoteNotifications() }
        }
        setWindow()
        return true
    }

    func setWindow(){
        let frame = UIScreen.main.bounds
        self.window = UIWindow(frame: frame)
        if Auth.auth().currentUser != nil {
            let maintabController = MainTabBarWireframe.createMainTabBarModule()
            let navController = UINavigationController(rootViewController: maintabController)
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        } else {
            let mainViewController = LoginOrSignUpWireframe.createLoginOrSignUpModule()
            let navController = UINavigationController(rootViewController: mainViewController)
            self.window?.rootViewController = navController
            self.window?.makeKeyAndVisible()
        }
    }
    
}


//MARK: - UNUserNotificationCenterDelegate and MessagingDelegate methods
extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate{
    
    
    //MARK: - didRegisterForRemoteNotificationsWithDeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //It takes two minutes to receive notification
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                print(error)
            } else {
                print(token ?? "") //This token must go when sending test message in fcm registration token
            }
        }
    }
    
    
    //MARK: - willPresent
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //CALLED ONLY WHEN IN APP-> UIAPPLICATIONSTATE = BACKGROUND
        //IF ANOTHER NOTIFICATION IS CALLED(A NEW ONE) MUST UPDATE BADGE NUMBER
        completionHandler([.sound, .badge, .alert]) //what will show(sound yes or no badge or alert)
        //When we're in the app state is background
        if state == .active{
            UIApplication.shared.applicationIconBadgeNumber += 1
        }else if state == .background{
            UIApplication.shared.applicationIconBadgeNumber += 1
            
        }else if state == .inactive{
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
    
    
    //MARK: - didReceive
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if state == .active{
            UIApplication.shared.applicationIconBadgeNumber += 1
        }else if state == .background{
            UIApplication.shared.applicationIconBadgeNumber += 1
            
        }else if state == .inactive{
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
        print(response)
        completionHandler()
    }
    
    
    //MARK: - didReceiveRegistrationToken
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else{return}
            print("Token: \(token)")
        }
    }
}


//MARK: - Application states
extension AppDelegate{
    
    
    //MARK: - applicationWillEnterForeground
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("willEnterForeground")//active
    }
    
    
    //MARK: - applicationDidBecomeActive
    func applicationDidBecomeActive(_ application: UIApplication) {
         print ("didEnterForeground")
    }
    
    
    //MARK: - applicationWillResignActive
    func applicationWillResignActive(_ application: UIApplication) {
        //if method willpresent is called badgenumber + 1
        print("willEnterBackground")
    }
    
    
    //MARK: - applicationDidEnterBackground
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("didEnterBackground")
    }
}

