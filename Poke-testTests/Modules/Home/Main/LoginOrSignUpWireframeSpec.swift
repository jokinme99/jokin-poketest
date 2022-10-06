//
//  LoginOrSignUpWireframeSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 1/6/22.
//

import Quick
import Nimble
@testable import Poke_test

class LoginOrSignUpWireframeSpec: QuickSpec {
    override func spec() {
        var view: UIViewController!
        var wireframe: LoginOrSignUpWireframe!
        beforeEach {
            view = LoginOrSignUpWireframe.createLoginOrSignUpModule()
            wireframe = LoginOrSignUpWireframe()
        }
        describe("Testing Wireframe") {
            context("create login or sign Up module method") {
                it("should create LoginOrSignUpViewController") {
                    expect(view.nibName).to(equal("LoginOrSignUpViewController"))
                }
            }
            context("open login window") {
                it("should open LoginViewController") {
                    wireframe.openLoginWindow()
                    expect(wireframe.loginModule?.nibName).to(equal("LoginViewController"))
                }
            }
            context("open sign up window") {
                it("should open SignUpViewController") {
                    wireframe.openSignUpWindow()
                    expect(wireframe.signUpModule?.nibName).to(equal("SignUpViewController"))
                }
            }
            context("open pokemon list window") {
                it("should open MainTabBarWireframe") {
                    wireframe.openPokemonListWindow()
                    expect(wireframe.listModule).notTo(beNil())
                }
            }
        }
    }
}
