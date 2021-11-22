//
//  SignUpPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

class SignUpPresenter : SignUpPresenterDelegate {
    var view: SignUpViewDelegate?
    var interactor: SignUpInteractorDelegate?
    var wireframe: SignUpWireframeDelegate?
    func openMainTabBar(){
        wireframe?.openMainTabBar()
    }
}

extension SignUpPresenter: SignUpInteractorOutputDelegate {

}
