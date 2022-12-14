//
//  SignUpWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit

class SignUpWireframe {
    var viewController: UIViewController?
}

extension SignUpWireframe: SignUpWireframeDelegate {
    static func createSignUpModule() -> UIViewController {
        let presenter = SignUpPresenter()
        let view = SignUpViewController()
        let wireframe = SignUpWireframe()

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
