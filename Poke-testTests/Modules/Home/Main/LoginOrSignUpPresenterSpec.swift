//
//  LoginOrSignUpPresenterSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 1/6/22.
//

import Quick
import Nimble
@testable import Poke_test

class LoginOrSignUpPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: LoginOrSignUpPresenter!
        var wireframe: LoginOrSignUpWireframe!
        beforeEach {
            presenter = LoginOrSignUpPresenter()
            wireframe = LoginOrSignUpWireframe()
            presenter.wireframe = wireframe
        }
        describe("Testing presenter") {
            context("open login window method") {
                it("should open LoginViewController") {
                    presenter.openLoginWindow()
                    expect(wireframe.loginModule?.nibName).to(equal("LoginViewController"))
                }
            }
            context("open sign up window method") {
                it("should open SignUpViewController") {
                    presenter.openSignUpWindow()
                    expect(wireframe.signUpModule?.nibName).to(equal("SignUpViewController"))
                }
            }
            context("open pokemon list window") {
                it("should open MainTabBarViewController") {
                    presenter.openPokemonListWindow()
                    expect(wireframe.listModule).notTo(beNil())
                }
            }
        }
    }
}
