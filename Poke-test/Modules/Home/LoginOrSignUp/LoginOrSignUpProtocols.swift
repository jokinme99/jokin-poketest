//
//  LoginOrSignUpProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit

protocol LoginOrSignUpWireframeDelegate: AnyObject {
    static func createLoginOrSignUpModule() -> UIViewController
    func openLoginWindow()
    func openSignUpWindow()
    func openPokemonListWindow()
}

protocol LoginOrSignUpPresenterDelegate: AnyObject {
    var wireframe: LoginOrSignUpWireframeDelegate? {get set}
    func openLoginWindow()
    func openSignUpWindow()
    func openPokemonListWindow()
}
