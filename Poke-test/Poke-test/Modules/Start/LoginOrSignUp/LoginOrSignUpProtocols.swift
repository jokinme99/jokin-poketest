//
//  LoginOrSignUpProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit

protocol LoginOrSignUpViewDelegate: AnyObject {
    var presenter: LoginOrSignUpPresenterDelegate? {get set}
}

protocol LoginOrSignUpWireframeDelegate: AnyObject {
    static func createLoginOrSignUpModule() -> UIViewController
    func openLoginWindow()
    func openSignUpWindow()
    func openPokemonListWindow()
}

protocol LoginOrSignUpPresenterDelegate: AnyObject {
    var view: LoginOrSignUpViewDelegate? {get set}
    var interactor: LoginOrSignUpInteractorDelegate? {get set}
    var wireframe: LoginOrSignUpWireframeDelegate? {get set}
    func openLoginWindow()
    func openSignUpWindow()
    func openPokemonListWindow()
}

protocol LoginOrSignUpInteractorDelegate: AnyObject {
    var presenter: LoginOrSignUpInteractorOutputDelegate? {get set}
}

protocol LoginOrSignUpInteractorOutputDelegate: AnyObject {

}
