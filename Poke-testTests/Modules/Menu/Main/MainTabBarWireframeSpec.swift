//
//  MainTabBarWireframeSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class MainTabBarWireframeSpec: QuickSpec {
    override func spec() {
        var wireframe: MainTabBarWireframe!
        beforeEach {
            wireframe = MainTabBarWireframe()
        }
        describe("Testing Wireframe") {
            context("open login or sign up window") {
                it("should open LoginOrSignUpWireframe") {
                    wireframe.openLoginSignUpWindow()
                    expect(wireframe.loginSignUpModule?.nibName).to(equal("LoginOrSignUpViewController"))
                }
            }
        }
    }
}
