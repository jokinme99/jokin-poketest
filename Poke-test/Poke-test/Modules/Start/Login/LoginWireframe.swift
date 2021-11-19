//
//  LoginWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit

class LoginWireframe : LoginWireframeDelegate {

    var viewController: UIViewController?

    static func createLoginModule() -> UIViewController {//Takes to mainTabBar
        let presenter = LoginPresenter()
        let view = LoginViewController()
        let wireframe = LoginWireframe()
        let interactor = LoginInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
    func openMainTabBar() {
        let mainTabModule = MainTabBarWireframe.createMainTabBarModule()
        //viewController?.navigationController.
        //Take to MAIN with no back buttons
    }
}
