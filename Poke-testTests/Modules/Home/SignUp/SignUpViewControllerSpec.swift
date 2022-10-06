//
//  viewControllerSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class SignUpViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: SignUpViewController!
        var presenter: SignUpPresenter!
        var wireframe: SignUpWireframe!
        beforeEach {
            viewController = SignUpViewController()
            presenter = SignUpPresenter()
            wireframe = SignUpWireframe()
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
                    expect(title).to(equal(HomeConstants.signUpButtonTitle))
                }
                it("should return background image") {
                    let backImage = viewController.backgroundImageView.image
                    let compareImage = UIImage(named: "launchScreenImage")
                    expect(backImage?.imageAsset).to(equal(compareImage?.imageAsset))
                }
                it("should return button title") {
                    let buttonTitle = viewController.enterButton.title(for: .normal)
                    expect(buttonTitle).to(equal(HomeConstants.enterButtonTitle))
                }
                it("should return text fields' placeholder values") {
                    let userPlaceholderText = viewController.userTextFieldController?.placeholderText
                    let passwordPlaceholderText = viewController.passwordTextFieldController?.placeholderText
                    expect(userPlaceholderText).to(equal(HomeConstants.emailTitle))
                    expect(passwordPlaceholderText).to(equal(HomeConstants.passwordTitle))
                }
            }
            context("navigation items") {
                it("should return items") {
                    let backButtonTitle = viewController.navigationItem.backButtonTitle
                    expect(backButtonTitle).to(equal(HomeConstants.backButtonTitle))
                }
            }
            context("enter button") {
                it("should send alert") {
                    viewController.createAlert(title: "Test", message: "Test message")
                    let alert = viewController.alert
                    expect(alert.nibName).to(equal("ZeroDialog"))
                }
                it("should open main window") {
                    viewController.presenter?.openMainTabBar()
                    expect(wireframe.listModule).notTo(beNil())
                }
            }
        }
    }
}
