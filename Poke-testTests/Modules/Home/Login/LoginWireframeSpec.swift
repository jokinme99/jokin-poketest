//
//  LoginWireframeSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 16/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class LoginWireframeSpec: QuickSpec {
    override func spec() {
        var wireframe: LoginWireframe!
        beforeEach {
            wireframe = LoginWireframe()
        }
        describe("Testing Wireframe") {
            context("open pokemon list window") {
                it("should open MainTabBarWireframe") {
                    wireframe.openMainTabBar()
                    expect(wireframe.listModule).notTo(beNil())
                }
            }
        }
    }
}
