//
//  LoginOrSignUpViewControllerSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 2/6/22.
//

import Quick
import Nimble
@testable import Poke_test
import UIKit
import FirebaseCrashlytics

class LoginOrSignUpViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: LoginOrSignUpViewController!
        var presenter: LoginOrSignUpPresenter!
        var wireframe: LoginOrSignUpWireframe!
        beforeEach {
            viewController = LoginOrSignUpViewController()
            presenter = LoginOrSignUpPresenter()
            wireframe = LoginOrSignUpWireframe()
            viewController.presenter = presenter
            viewController.presenter?.wireframe = wireframe
            presenter.wireframe = wireframe
            expect(viewController.view).notTo(beNil())
            viewController.viewDidLoad()
        }
        describe("Testing View Controller") {
            context("outlet objects") {
                it("should return title") {
                    let title = viewController.titleLabel.text
                    expect(title).to(equal(HomeConstants.welcomeTitle))
                }
                it("should return background image") {
                    let backImage = viewController.backgroundImageView.image
                    expect(backImage).to(equal(UIImage(named: "launchScreenImage")))
                }
                it("should return buttons") {
                    let loginButtonTitle = viewController.toLoginMenuButton.title(for: .normal)
                    expect(loginButtonTitle).to(equal(HomeConstants.loginButtonTitle))
                    let signUpButtonTitle = viewController.toSignUpMenuButton.title(for: .normal)
                    expect(signUpButtonTitle).to(equal(HomeConstants.signUpButtonTitle))
                    let noUserButtonTitle = viewController.notLoginOrSignUpButton.title(for: .normal)
                    expect(noUserButtonTitle).to(equal(HomeConstants.noUserButtonTitle))
                }
            }
            context("navigation items") {
                it("should return titles") {
                    let backButtonTitle = viewController.navigationItem.backButtonTitle
                    expect(backButtonTitle).to(equal(HomeConstants.backButtonTitle))
                    let mainTitle = viewController.navigationItem.title
                    expect(mainTitle).to(equal(HomeConstants.navigationItemTitle))
                }
            }
            context("open settings") {
                it("should open settings") {
                    viewController.openSettings()
                    let url = viewController.url
                    expect(url).to(equal(URL(string: UIApplication.openSettingsURLString)))

                }
            }
            context("crashlytics errors") {
                it("should return true if crashlytics is enabled") {
                    expect(true).to(equal(Crashlytics.crashlytics().isCrashlyticsCollectionEnabled()))
                }
            }
            context("pressing login button") {
                it("should return the expected action") {
                    viewController.pressedToLoginMenuButton((Any).self)
                    if Reachability.isConnectedToNetwork() {
                        expect(wireframe.loginModule?.nibName).to(equal("LoginViewController"))
                    } else {
                        let alertTitle = viewController.alert.title
                        expect(alertTitle).to(equal(HomeConstants.noInternetTitle))
                    }
                }
            }
            context("pressing sign up button") {
                it("should return the expected action") {
                    viewController.pressedToSignUpMenuButton((Any).self)
                    if Reachability.isConnectedToNetwork() {
                        expect(wireframe.signUpModule?.nibName).to(equal("SignUpViewController"))
                    } else {
                        let alertTitle = viewController.alert.title
                        expect(alertTitle).to(equal(HomeConstants.noInternetTitle))
                    }
                }
            }
            context("pressing no user button") {
                it("should return the expected action") {
                    viewController.pressedNotLoginOrSignUpButton((Any).self)
                    expect(wireframe.listModule).notTo(beNil())
                }
            }
        }
    }
}
