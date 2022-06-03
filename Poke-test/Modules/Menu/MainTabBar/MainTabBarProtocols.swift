//
//  MainTabBarProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//
import UIKit

protocol MainTabBarViewDelegate: AnyObject {
    var presenter: MainTabBarPresenterDelegate? {get set}
}

protocol MainTabBarWireframeDelegate: AnyObject {
    static func createMainTabBarModule() -> UIViewController
    func openLoginSignUpWindow()
}

protocol MainTabBarPresenterDelegate: AnyObject {
    var view: MainTabBarViewDelegate? {get set}
    var interactor: MainTabBarInteractorDelegate? {get set}
    var wireframe: MainTabBarWireframeDelegate? {get set}
    func openLoginSignUpWindow()
}

protocol MainTabBarInteractorDelegate: AnyObject {
    var presenter: MainTabBarInteractorOutputDelegate? {get set}
}

protocol MainTabBarInteractorOutputDelegate: AnyObject {

}
