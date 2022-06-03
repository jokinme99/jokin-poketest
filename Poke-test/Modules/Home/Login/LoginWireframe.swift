//
//  LoginWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit

class LoginWireframe {
    var viewController: UIViewController?
}

extension LoginWireframe: LoginWireframeDelegate {
    static func createLoginModule() -> UIViewController {
        let presenter = LoginPresenter()
        let view = LoginViewController()
        let wireframe = LoginWireframe()

        view.presenter = presenter
        presenter.wireframe = wireframe

        wireframe.viewController = view

        return view
    }
    func openMainTabBar() {
        let listModule = MainTabBarWireframe.createMainTabBarModule()
        let navigation = UINavigationController(rootViewController: listModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
