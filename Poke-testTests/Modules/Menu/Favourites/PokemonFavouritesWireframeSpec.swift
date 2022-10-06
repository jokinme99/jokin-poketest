//
//  PokemonFavouritesWireframeSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 21/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class PokemonFavouritesWireframeSpec: QuickSpec {
    override func spec() {
        var wireframe: PokemonFavouritesWireframe!
        var results1: Results!
        var results2: Results!
        var results3: Results!
        var filtered: [Results]!
        beforeEach {
            wireframe = PokemonFavouritesWireframe()
            results1 = Results(name: "A")
            results2 = Results(name: "B")
            results3 = Results(name: "C")
            filtered = [results1, results2, results3]
        }
        describe("Testing Wireframe") {
            context("open details window") {
                it("should open PokemonDetailsViewController") {
                    wireframe.openPokemonDetailsWindow(
                        pokemon: results1, nextPokemon: results2, previousPokemon: results3, filtered: filtered)
                    expect(wireframe.detailsModule?.nibName).to(equal("PokemonDetailsViewController"))
                }
            }
            context("open login or sign up window") {
                it("should open LoginOrSignUpViewController") {
                    wireframe.openLoginSignUpWindow()
                    expect(wireframe.loginSignUpModule).notTo(beNil())
                }
            }
            context("open main tab bar") {
                it("should open MainTabBarViewController") {
                    wireframe.openPokemonListWindow()
                    expect(wireframe.mainTabBarModule).notTo(beNil())
                }
            }
        }
    }
}
