//
//  LoginOrSignUpWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit

class LoginOrSignUpWireframe {
    var viewController: UIViewController?
    var loginModule: UIViewController?
    var signUpModule: UIViewController?
    var listModule: UIViewController?
}

extension LoginOrSignUpWireframe: LoginOrSignUpWireframeDelegate {
    static func createLoginOrSignUpModule() -> UIViewController {
        let presenter = LoginOrSignUpPresenter()
        let view = LoginOrSignUpViewController()
        let wireframe = LoginOrSignUpWireframe()

        view.presenter = presenter
        presenter.wireframe = wireframe
        wireframe.viewController = view
        return view
    }
    func openLoginWindow() {
        loginModule = LoginWireframe.createLoginModule()
        guard let loginModule = loginModule else { return }
        viewController?.navigationController?.pushViewController(loginModule, animated: true)
    }
    func openSignUpWindow() {
        signUpModule = SignUpWireframe.createSignUpModule()
        guard let signUpModule = signUpModule else { return }
        viewController?.navigationController?.pushViewController(signUpModule, animated: true)
    }
    func openPokemonListWindow() {
        listModule = MainTabBarWireframe.createMainTabBarModule()
        guard let listModule = listModule else { return }
        viewController?.navigationController?.setViewControllers([listModule], animated: true)
    }
}
