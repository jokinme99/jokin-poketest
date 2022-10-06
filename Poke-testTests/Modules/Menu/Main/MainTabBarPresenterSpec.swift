//
//  MainTabBarPresenterSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class MainTabBarPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: MainTabBarPresenter!
        var wireframe: MainTabBarWireframe!
        beforeEach {
            presenter = MainTabBarPresenter()
            wireframe = MainTabBarWireframe()
            presenter.wireframe = wireframe
        }
        describe("Testing presenter") {
            context("open login or sign up window") {
                it("should open LoginOrSignUpViewController") {
                    presenter.openLoginSignUpWindow()
                    expect(wireframe.loginSignUpModule?.nibName).to(equal("LoginOrSignUpViewController"))
                }
            }
        }
    }
}
