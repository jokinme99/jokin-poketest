//
//  DataSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 27/5/22.
//

import Nimble
import Quick
import UIKit
import class RealmSwift.Object
import class RealmSwift.List
@testable import Poke_test

class DataSpec: QuickSpec {
    override func spec() {
        var results: [Results]!
        var pokemonListData: PokemonListData!
        var favourites: Favourites!
        var pokemonData: PokemonData!
        var types: [Types]!
        var stats: [Stats]!
        var abilities: [Abilities]!
        var pokemonFilterListData: PokemonFilterListData!
        var pokemons: [Pokemons]!
        var pokemonDictionary: PokemonDictionary!
        let pokemonExampleName = "bulbasaur"
        beforeEach {
            results = [
                Results(name: pokemonExampleName),
                Results(name: "charmander"),
                Results(name: "squirtle")
            ]
            pokemonListData = PokemonListData(
                results: results.transformArrayToList())
            favourites = Favourites(name: pokemonExampleName)
            types = [
                Types(type: Type(name: "grass")),
                Types(type: Type(name: "poison"))
            ]
            stats = [
                Stats(baseStat: 8), Stats(baseStat: 15),
                Stats(baseStat: 12), Stats(baseStat: 11),
                Stats(baseStat: 10), Stats(baseStat: 9)
            ]
            abilities = [
                Abilities(ability: Ability(name: "Ability 1")),
                Abilities(ability: Ability(name: "Ability 2"))
            ]
            pokemonData = PokemonData(
                name: pokemonExampleName, sprites: Sprites(frontDefault: "frontDefault"),
                types: types.transformArrayToList(), id: 1, height: 14, weight: 24,
                stats: stats.transformArrayToList(), abilities: abilities.transformArrayToList())
            pokemons = [
                Pokemons(pokemon: Pokemon(name: pokemonExampleName)),
                Pokemons(pokemon: Pokemon(name: "ivysaur"))
            ]
            pokemonFilterListData = PokemonFilterListData(
                name: "grass", pokemon: pokemons.transformArrayToList())
            pokemonDictionary = PokemonDictionary(pokemonInDict: Results(name: pokemonExampleName), pokemonId: 0)
        }
        describe("Testing data") {
            context("pokémon list data") {
                it("should return the same Results object") {
                    expect(pokemonListData.results[0]).to(equal(results[0]))
                }
            }
            context("favourites") {
                it("should return the same name") {
                    expect(favourites.name).to(equal(pokemonExampleName))
                }
            }
            context("pokémon data") {
                it("should return the same features") {
                    expect(pokemonData.name).to(equal(pokemonExampleName))
                    expect(pokemonData.sprites?.frontDefault).to(equal("frontDefault"))
                    expect(pokemonData.abilities[0].ability?.name).to(equal("Ability 1"))
                }
            }
            context("pokémon filter list data") {
                it("should return the same type and pokémon") {
                    expect(pokemonFilterListData.name).to(equal("grass"))
                    expect(pokemonFilterListData.pokemon[1].pokemon?.name).to(equal("ivysaur"))
                }
            }
            context("pokémon dictionary") {
                it("should return the same id and name") {
                    expect(pokemonDictionary.pokemonId).to(equal(0))
                    expect(pokemonDictionary.pokemonInDict?.name).to(equal(pokemonExampleName))
                }
            }
        }

    }
}
