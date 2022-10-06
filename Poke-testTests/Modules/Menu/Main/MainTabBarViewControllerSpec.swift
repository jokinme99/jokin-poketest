//
//  MainTabBarViewControllerSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
import FirebaseAuth
@testable import Poke_test

class MainTabBarViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: MainTabBarViewController!
        var presenter: MainTabBarPresenter!
        var wireframe: MainTabBarWireframe!
        beforeEach {
            viewController = MainTabBarViewController()
            presenter = MainTabBarPresenter()
            wireframe = MainTabBarWireframe()
            viewController.presenter = presenter
            viewController.presenter?.wireframe = wireframe
            presenter.wireframe = wireframe
            expect(viewController.view).notTo(beNil())
            viewController.viewDidLoad()
        }
        describe("Testing View Controller") {
            context("outlet objects") {
                it("should return title") {
                    let title = viewController.navigationItem.title
                    expect(title).to(equal(MenuConstants.navigationItemTitle))
                }
                it("should return tabs' names") {
                    let listTitle = viewController
                        .viewControllers?[0].tabBarItem.title
                    expect(listTitle).to(equal(MenuConstants.listTabBar))
                    let collectionTitle = viewController.viewControllers?[1].tabBarItem.title
                    expect(collectionTitle).to(equal(MenuConstants.collectionTabBar))
                    let favouritesTitle = viewController.viewControllers?[2].tabBarItem.title
                    expect(favouritesTitle).to(equal(MenuConstants.favsListBar))
                }
                it("should return right bar button title") {
                    let rightBarButtonTitle = viewController.navigationItem.rightBarButtonItem?.title
                    if Auth.auth().currentUser != nil {
                        expect(rightBarButtonTitle).to(equal(MenuConstants.titleLogOut))
                    } else {
                        expect(rightBarButtonTitle).to(equal(MenuConstants.titleLogIn))
                    }
                }
                it("should return ViewControllers") {
                    let listTab = viewController.viewControllers?[0]
                    expect(listTab?.nibName).to(equal("PokemonListViewController"))
                    let collectionTab = viewController.viewControllers?[1]
                    expect(collectionTab?.nibName).to(equal("PokemonCollectionViewController"))
                    let favouritesTab = viewController.viewControllers?[2]
                    expect(favouritesTab?.nibName).to(equal("PokemonFavouritesViewController"))
                }
            }
            context("buttons") {
                it("should open LoginOrSignUpViewController") {
                    viewController.presenter?.openLoginSignUpWindow()
                    expect(wireframe.loginSignUpModule).notTo(beNil())
                }
            }
        }
    }
}
