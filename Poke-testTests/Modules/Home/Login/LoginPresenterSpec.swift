//
//  LoginPresenterSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 16/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class LoginPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: LoginPresenter!
        var wireframe: LoginWireframe!
        beforeEach {
            presenter = LoginPresenter()
            wireframe = LoginWireframe()
            presenter.wireframe = wireframe
        }
        describe("Testing presenter") {
            context("open pokemon list window") {
                it("should open MainTabBarViewController") {
                    presenter.openMainTabBar()
                    expect(wireframe.listModule).notTo(beNil())
                }
            }
        }
    }
}
