//
//  SignUpWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit

class SignUpWireframe : SignUpWireframeDelegate {

    var viewController: UIViewController?

    static func createSignUpModule() -> UIViewController {
        let presenter = SignUpPresenter()
        let view = SignUpViewController()
        let wireframe = SignUpWireframe()
        let interactor = SignUpInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
}
