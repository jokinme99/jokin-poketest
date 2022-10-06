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
import Zero

@main
class AppDelegate: UIResponder {
    var window: UIWindow?
    var user: User?
    var state = UIApplication.shared.applicationState
}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
        -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        application.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else {return}
            print("Success in APN registry")
            DispatchQueue.main.async { application.registerForRemoteNotifications() }
        }
        setWindow()
        return true
    }

    func setWindow() {

        let frame = UIScreen.main.bounds
        user = Auth.auth().currentUser
        self.window = UIWindow(frame: frame)
        if UIApplication.isFirstLaunch() {
            if user != nil {
                logOut()
            }
            self.openUserNotLogged()
            showAlert()
        } else {
            if user != nil {
                self.openUserLogged()
            } else {
                self.openUserNotLogged()
            }
        }
    }
    func showAlert() {
        ZeroDialog().show(
            title: MenuConstants.saveDataTitle,
            info: MenuConstants.saveDataInfo,
            titleOk: MenuConstants.yesTitle,
            titleCancel: MenuConstants.noTitle,
            completionOk: {
                PokemonManager.shared.saveDataOffline = true
            },
            completionCancel: nil
        )
    }
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func openUserLogged() {
        let maintabController = MainTabBarWireframe.createMainTabBarModule()
        let navController = UINavigationController(rootViewController: maintabController)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
    }
    func openUserNotLogged() {
        let mainViewController = LoginOrSignUpWireframe.createLoginOrSignUpModule()
        let navController = UINavigationController(rootViewController: mainViewController)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()

    }
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // It takes two minutes to receive notification
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                print(error)
            } else {
                print(token ?? "")
            }
        }
    }
    func userNotificationCenter(
        _ center: UNUserNotificationCenter, willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .alert])
        if state == .active {
            UIApplication.shared.applicationIconBadgeNumber += 1
        } else if state == .background {
            UIApplication.shared.applicationIconBadgeNumber += 1
        } else if state == .inactive {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
    }
    func userNotificationCenter(
        _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        if state == .active {
            UIApplication.shared.applicationIconBadgeNumber += 1
        } else if state == .background {
            UIApplication.shared.applicationIconBadgeNumber += 1
        } else if state == .inactive {
            UIApplication.shared.applicationIconBadgeNumber += 1
        }
        completionHandler()
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { _, _ in
        }
    }
}

extension AppDelegate {
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    func applicationWillResignActive(_ application: UIApplication) {
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
}
