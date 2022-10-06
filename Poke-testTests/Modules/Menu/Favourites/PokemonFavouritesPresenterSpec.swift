//
//  PokemonFavouritesPresenterSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 21/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class PokemonFavouritesPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: PokemonFavouritesPresenter!
        var wireframe: PokemonFavouritesWireframe!
        var results1: Results!
        var results2: Results!
        var results3: Results!
        var filtered: [Results]!
        beforeEach {
            presenter = PokemonFavouritesPresenter()
            wireframe = PokemonFavouritesWireframe()
            presenter.wireframe = wireframe
            results1 = Results(name: "A")
            results2 = Results(name: "B")
            results3 = Results(name: "C")
            filtered = [results1, results2, results3]
        }
        describe("Testing presenter") {
            context("open details window") {
                it("should open PokemonDetailsViewController") {
                    presenter.openPokemonDetail(
                        pokemon: results1, nextPokemon: results2, previousPokemon: results3, filtered: filtered)
                    expect(wireframe.detailsModule?.nibName).to(equal("PokemonDetailsViewController"))
                }
            }
            context("open login or sign up window") {
                it("should open LoginOrSignUpViewController") {
                    presenter.openLoginSignUpWindow()
                    expect(wireframe.loginSignUpModule).notTo(beNil())
                }
            }
            context("open main tab bar") {
                it("should open MainTabBarViewController") {
                    presenter.openPokemonListWindow()
                    expect(wireframe.mainTabBarModule).notTo(beNil())
                }
            }
        }
    }
}
