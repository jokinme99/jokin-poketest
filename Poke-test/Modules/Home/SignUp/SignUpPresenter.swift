//
//  SignUpPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
class SignUpPresenter{
    
    var wireframe: SignUpWireframeDelegate?
    
}

extension SignUpPresenter: SignUpPresenterDelegate{

    func openMainTabBar(){
        wireframe?.openMainTabBar()
    }
}

