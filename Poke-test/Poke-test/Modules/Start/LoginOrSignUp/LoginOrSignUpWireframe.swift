//
//  LoginOrSignUpWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit

class LoginOrSignUpWireframe : LoginOrSignUpWireframeDelegate {
    var viewController: UIViewController?

    static func createLoginOrSignUpModule() -> UIViewController {
        let presenter = LoginOrSignUpPresenter()
        let view = LoginOrSignUpViewController()
        let wireframe = LoginOrSignUpWireframe()
        let interactor = LoginOrSignUpInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
    func openLoginWindow() {
        let loginModule = LoginWireframe.createLoginModule()
        viewController?.present(loginModule, animated: true, completion: nil)
    }
    
    func openSignUpWindow() {
        let signUpModule = SignUpWireframe.createSignUpModule()
        viewController?.present(signUpModule, animated: true, completion: nil)
    }
    func openPokemonListWindow() {
        let listModule = PokemonListWireframe.createPokemonListModule()
        let a = viewController?.nibName
        viewController?.navigationController?.storyboard?.instantiateViewController(withIdentifier: listModule.nibName!)
        //viewController.active
        //viewController?.navigationController?.pushViewController(listModule, animated: true)
    }
    
}
