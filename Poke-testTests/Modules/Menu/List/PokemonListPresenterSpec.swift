//
//  PokemonListPresenterSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

// Fetch methods should be tested?

class PokemonListPresenterSpec: QuickSpec {
    override func spec() {
        var presenter: PokemonListPresenter!
        var wireframe: PokemonListWireframe!
        var results1: Results!
        var results2: Results!
        var results3: Results!
        var filtered: [Results]!
        beforeEach {
            presenter = PokemonListPresenter()
            wireframe = PokemonListWireframe()
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
                        pokemon: results1, nextPokemon: results2,
                        previousPokemon: results3, filtered: filtered)
                    expect(wireframe.detailsModule?.nibName).to(equal("PokemonDetailsViewController"))
                }
            }
            context("open login or sign up window") {
                it("should open LoginOrSignUpViewController") {
                    presenter.openLoginSignUpWindow()
                    expect(wireframe.loginSignUpModule).notTo(beNil())
                }
            }
        }
    }
}
