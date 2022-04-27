//
//  LoginOrSignUpPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
class LoginOrSignUpPresenter{
    
    var wireframe: LoginOrSignUpWireframeDelegate?
    
}

extension LoginOrSignUpPresenter: LoginOrSignUpPresenterDelegate{

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

