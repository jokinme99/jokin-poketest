//
//  SignUpProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit

protocol SignUpViewDelegate: AnyObject {
    var presenter: SignUpPresenterDelegate? {get set}
}

protocol SignUpWireframeDelegate: AnyObject {
    static func createSignUpModule() -> UIViewController
}

protocol SignUpPresenterDelegate: AnyObject {
    var view: SignUpViewDelegate? {get set}
    var interactor: SignUpInteractorDelegate? {get set}
    var wireframe: SignUpWireframeDelegate? {get set}
}

protocol SignUpInteractorDelegate: AnyObject {
    var presenter: SignUpInteractorOutputDelegate? {get set}
}

protocol SignUpInteractorOutputDelegate: AnyObject {

}
