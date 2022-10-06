//
//  AppDelegateSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 25/5/22.
//

// describe -> context -> it

import Nimble
import Quick
import FirebaseAuth
@testable import Poke_test

class AppDelegateSpec: QuickSpec {
    override func spec() {
        var appDelegate: AppDelegate!
        beforeEach {
            appDelegate = AppDelegate()
        }
        describe("Starting app") {
            context("set window method") {
                it("should return window and user") {
                    appDelegate.setWindow()
                    expect(appDelegate.window).notTo(beNil())
                    if Auth.auth().currentUser != nil {
                        expect(appDelegate.user).notTo(beNil())
                    } else {
                        expect(appDelegate.user).to(beNil())
                    }
                }
            }

        }
    }
}
