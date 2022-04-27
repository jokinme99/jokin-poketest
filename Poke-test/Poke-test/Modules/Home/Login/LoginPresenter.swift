//
//  LoginPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
class LoginPresenter{
    var wireframe: LoginWireframeDelegate?
    
}

extension LoginPresenter: LoginPresenterDelegate{
    func openMainTabBar() {
        wireframe?.openMainTabBar()
    }
}


