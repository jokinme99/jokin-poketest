//
//  SignUpProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit


protocol SignUpWireframeDelegate: AnyObject {
    static func createSignUpModule() -> UIViewController
    func openMainTabBar()
}

protocol SignUpPresenterDelegate: AnyObject {
    var wireframe: SignUpWireframeDelegate? {get set}
    func openMainTabBar()
}

