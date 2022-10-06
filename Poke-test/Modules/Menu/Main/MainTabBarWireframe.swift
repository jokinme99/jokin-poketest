//
//  MainTabBarWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//
import UIKit

class MainTabBarWireframe {

    var viewController: UIViewController?
    var loginSignUpModule: UIViewController?

    static func createMainTabBarModule() -> UIViewController {
        let presenter = MainTabBarPresenter()
        let view = MainTabBarViewController()
        let wireframe = MainTabBarWireframe()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        wireframe.viewController = view

        return view
    }
}

extension MainTabBarWireframe: MainTabBarWireframeDelegate {
    func openLoginSignUpWindow() {
        loginSignUpModule = LoginOrSignUpWireframe.createLoginOrSignUpModule()
        guard let loginSignUpModule = loginSignUpModule else {return}
        let navigation = UINavigationController(rootViewController: loginSignUpModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
