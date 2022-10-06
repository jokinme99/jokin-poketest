//
//  SignUpPresenterSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble

@testable import Poke_test

class SignUpPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: SignUpPresenter!
        var wireframe: SignUpWireframe!
        beforeEach {
            presenter = SignUpPresenter()
            wireframe = SignUpWireframe()
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
