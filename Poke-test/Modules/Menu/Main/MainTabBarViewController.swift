//
//  MainTabBarViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics
import Zero

class MainTabBarViewController: ZeroTabBarViewController {
    var presenter: MainTabBarPresenterDelegate?
    var list: UIViewController!
    var favourites: UIViewController!
    var collection: UIViewController!
    var titleLog: String?
    var isLogged: Bool?
    let user = Auth.auth().currentUser
    var alert = ZeroDialog()
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        crashlyticsErrorSending()
    }
}

extension MainTabBarViewController {
    func setLoggingSettings() {
        if user != nil {
            titleLog = MenuConstants.titleLogOut
        } else {
            titleLog = MenuConstants.titleLogIn
        }
    }
    func setTabBar() {
        list = PokemonListWireframe.createPokemonListModule()
        list.tabBarItem = UITabBarItem(
            title: MenuConstants.listTabBar, image: .customTabBarImage1, selectedImage: .customTabBarImageSelected1)
        favourites = PokemonFavouritesWireframe.createPokemonFavouritesModule()
        favourites.tabBarItem = UITabBarItem(
            title: MenuConstants.favsListBar, image: .customTabBarImage2, selectedImage: .customTabBarImageSelected2)
        setLoggingSettings()
        collection = PokemonCollectionWireframe.createPokemonCollectionModule()
        collection.tabBarItem = UITabBarItem(
            title: MenuConstants.collectionTabBar,
            image: .customTabBarImage3, selectedImage: .customTabBarImageSelected3)
        setViewControllers([list, collection, favourites], animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: titleLog, style: .plain, target: self, action: #selector(logMethod))
        navigationItem.title = MenuConstants.navigationItemTitle
        navigationItem.titleView?.apply(ZeroTheme.Label.head1)
    }
    func crashlyticsErrorSending() {
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: CrashlyticsConstants.key)
        Crashlytics.crashlytics().log(CrashlyticsConstants.TabBar.log)
    }
}

extension MainTabBarViewController {
    @objc func logMethod() {
        if self.titleLog == MenuConstants.titleLogOut {
            alert.show(
                title: MenuConstants.loggingOutTitle + " \(user?.email ?? "")",
                info: MenuConstants.loggingOutMessage,
                titleOk: MenuConstants.yesTitle,
                titleCancel: MenuConstants.noTitle,
                completionOk: {
                    self.titleLog = MenuConstants.titleLogIn
                    self.logOut()
                    self.presenter?.openLoginSignUpWindow()
                },
                completionCancel: nil
            )
        } else {
            self.presenter?.openLoginSignUpWindow()
        }
    }
    func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension MainTabBarViewController: MainTabBarViewDelegate {
}
