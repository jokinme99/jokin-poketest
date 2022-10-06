//
//  MainTabBarPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//
class MainTabBarPresenter: MainTabBarPresenterDelegate {
    var view: MainTabBarViewDelegate?
    var wireframe: MainTabBarWireframeDelegate?
    func openLoginSignUpWindow() {
        wireframe?.openLoginSignUpWindow()
    }
}
