//
//  AppDelegate.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseAuth

@main
class AppDelegate: UIResponder{
    
    var window: UIWindow?
    var state = UIApplication.shared.applicationState
    
}

extension AppDelegate: UIApplicationDelegate{
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print(NSHomeDirectory()) To see the document directory (Application supports iTunes file sharing = YES, in order to be able to see the archives the APP has)
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

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        //It takes two minutes to receive notification
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                print(error)
            } else {
                print(token ?? "")
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .alert])
        if state == .active{
            UIApplication.shared.applicationIconBadgeNumber += 1
        }else if state == .background{
            UIApplication.shared.applicationIconBadgeNumber += 1
            
        }else if state == .inactive{
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
    
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
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else{return}
            print("Token: \(token)")
        }
    }
}

extension AppDelegate{
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
}

