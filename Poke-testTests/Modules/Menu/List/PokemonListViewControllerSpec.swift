//
//  PokemonListViewControllerSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

// Test tableView and delegates??

class PokemonListViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: PokemonListViewController!
        var presenter: PokemonListPresenter!
        var wireframe: PokemonListWireframe!
        var results1: Results!
        var results2: Results!
        var results3: Results!
        var filtered: [Results]!
        beforeEach {
            viewController = PokemonListViewController()
            presenter = PokemonListPresenter()
            wireframe = PokemonListWireframe()
            viewController.presenter = presenter
            viewController.presenter?.wireframe = wireframe
            presenter.wireframe = wireframe
            results1 = Results(name: "A")
            results2 = Results(name: "B")
            results3 = Results(name: "C")
            filtered = [results1, results2, results3]
            viewController.filtered = filtered
            expect(viewController.view).notTo(beNil())
            viewController.viewDidLoad()
        }
        describe("Testing View Controller") {
            context("outlet objects") {
                it("should return order button title") {
                    let buttonTitle = viewController.orderByButton.title(for: .normal)
                    expect(buttonTitle).to(equal(MenuConstants.orderByNameButtonTitle))
                }
                it("should return search bar placeholder") {
                    let searchBarPlaceholder = viewController.searchBar.placeholder
                    expect(searchBarPlaceholder).to(equal(MenuConstants.searchBarPlaceholder))
                }
                it("should return filter buttons count") {
                    let buttonCount = viewController.buttonList.count
                    expect(buttonCount).to(equal(21))
                }
            }
            context("search bar function") {
                it("should return empty") {
                    viewController.cleanSearchBar()
                    let searchBarText = viewController.searchBar.text
                    expect(searchBarText).to(equal(""))
                }
            }
        }
    }
}
