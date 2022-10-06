//
//  SignUpWireframeSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class SignUpWireframeSpec: QuickSpec {
    override func spec() {
        var wireframe: SignUpWireframe!
        beforeEach {
            wireframe = SignUpWireframe()
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
