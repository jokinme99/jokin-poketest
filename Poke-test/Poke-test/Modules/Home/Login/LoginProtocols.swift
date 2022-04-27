//
//  LoginProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit



protocol LoginWireframeDelegate: AnyObject {
    static func createLoginModule() -> UIViewController
    func openMainTabBar()
}

protocol LoginPresenterDelegate: AnyObject {
    var wireframe: LoginWireframeDelegate? {get set}
    func openMainTabBar()
}

