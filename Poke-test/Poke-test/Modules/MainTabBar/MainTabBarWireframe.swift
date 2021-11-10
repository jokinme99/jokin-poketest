//
//  MainTabBarWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//

import UIKit

class MainTabBarWireframe : MainTabBarWireframeDelegate {

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