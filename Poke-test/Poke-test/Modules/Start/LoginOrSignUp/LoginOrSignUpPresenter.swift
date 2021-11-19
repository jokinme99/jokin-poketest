//
//  LoginOrSignUpPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

class LoginOrSignUpPresenter : LoginOrSignUpPresenterDelegate {
    var view: LoginOrSignUpViewDelegate?
    var interactor: LoginOrSignUpInteractorDelegate?
    var wireframe: LoginOrSignUpWireframeDelegate?
    func openLoginWindow() {
        wireframe?.openLoginWindow()
    }
    
    func openSignUpWindow() {
        wireframe?.openSignUpWindow()
    }
    func openPokemonListWindow() {
        wireframe?.openPokemonListWindow()
    }
}

extension LoginOrSignUpPresenter: LoginOrSignUpInteractorOutputDelegate {

}
