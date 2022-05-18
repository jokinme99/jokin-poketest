//
//  MainTabBarWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//
import UIKit

class MainTabBarWireframe{

    var viewController: UIViewController?

    static func createMainTabBarModule() -> UIViewController {
        let presenter = MainTabBarPresenter()
        let view = MainTabBarViewController()
        let wireframe = MainTabBarWireframe()
        let interactor = MainTabBarInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
}

extension MainTabBarWireframe: MainTabBarWireframeDelegate{
    func openLoginSignUpWindow(){
        let loginSignUpModule = LoginOrSignUpWireframe.createLoginOrSignUpModule()
        let navigation = UINavigationController(rootViewController: loginSignUpModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
