//
//  LoginProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit

protocol LoginViewDelegate: AnyObject {
    var presenter: LoginPresenterDelegate? {get set}
}

protocol LoginWireframeDelegate: AnyObject {
    static func createLoginModule() -> UIViewController
    func openMainTabBar()
}

protocol LoginPresenterDelegate: AnyObject {
    var view: LoginViewDelegate? {get set}
    var interactor: LoginInteractorDelegate? {get set}
    var wireframe: LoginWireframeDelegate? {get set}
    func openMainTabBar()
}

protocol LoginInteractorDelegate: AnyObject {
    var presenter: LoginInteractorOutputDelegate? {get set}
}

protocol LoginInteractorOutputDelegate: AnyObject {

}
