//
//  LoginPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

class LoginPresenter : LoginPresenterDelegate {
    var view: LoginViewDelegate?
    var interactor: LoginInteractorDelegate?
    var wireframe: LoginWireframeDelegate?
    func openMainTabBar() {
        wireframe?.openMainTabBar()
    }
}

extension LoginPresenter: LoginInteractorOutputDelegate {

}
