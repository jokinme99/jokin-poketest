//
//  DataManagerSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 25/5/22.
//

import Nimble
import Quick
@testable import Poke_test

// Takes time because the method fetch list is called to get all data from the API and to save that data in the DB
class PokemonManagerSpec: QuickSpec {
    override func spec() {
        var pokemonManager: PokemonManager!
        let pokemonNameToTest = "bulbasaur"
        var typeToTest: String!
        beforeEach {
            pokemonManager = PokemonManager.shared
            typeToTest = TypeName.normal.rawValue
        }
        describe("Fetching") {
            context("pokemon list") {
                it("should return all the pokémon") {
                    waitUntil(timeout: .never) { done in
                        pokemonManager.fetchList({ pokemonList, error in
                            if let pokemonList = pokemonList {
                                expect(error).to(beNil())
                                expect(pokemonList.results.count).to(equal(1126))
                                expect(pokemonList.results.first?.name).to(equal(pokemonNameToTest))
                            } else {
                                expect(error).notTo(beNil())
                            }
                            done()
                        })
                    }

                }
            }
            context("pokemon details") {
                it("should return all the details") {
                    waitUntil(timeout: .never) { done in
                        pokemonManager.fetchPokemon(pokemonSelectedName: pokemonNameToTest) { pokemonData, error in
                            if let pokemonData = pokemonData {
                                expect(error).to(beNil())
                                expect(pokemonData.height).notTo(equal(0))
                                expect(pokemonData.weight).notTo(equal(0))
                                expect(pokemonData.types).notTo(beNil())
                                expect(pokemonData.abilities).notTo(beNil())
                            } else {
                                expect(error).notTo(beNil())
                            }
                            done()
                        }
                    }
                }
            }
            context("pokemon types") {
                it("should return all the types") {
                    waitUntil(timeout: .never) { done in
                        pokemonManager.fetchPokemonTypes(pokemonType: typeToTest) { pokemonFilterListData, error in
                            if let pokemonFilterListData = pokemonFilterListData {
                                expect(error).to(beNil())
                                expect(pokemonFilterListData.pokemon.count).to(equal(131))
                                expect(pokemonFilterListData.pokemon[0].pokemon?.name).to(equal("pidgey"))
                            } else {
                                expect(error).notTo(beNil())
                            }
                            done()
                        }
                    }
                }
            }
        }
    }
}
