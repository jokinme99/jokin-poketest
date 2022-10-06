//
//  PokemonCellSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 22/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
@testable import Poke_test

class PokemonCellSpec: QuickSpec {
    override func spec() {
        var cell: PokemonCell!
        var idLabel: UILabel!
        var pokemonNameLabel: UILabel!
        var result: Results!
        beforeEach {
            cell = PokemonCell()
            idLabel = UILabel()
            pokemonNameLabel = UILabel()
            cell.idLabel = idLabel
            cell.pokemonNameLabel = pokemonNameLabel
            result = Results(name: "bulbasaur")
        }
        describe("Testing table view cell") {
            context("color functions") {
                it("should return exact color") {
                    cell.setColor(TypeName.electric.rawValue, label)
                    let colorTesting = UIColor(
                        red: 248/255, green: 208/255, blue: 48/255, alpha: 1)
                    expect(label.backgroundColor).to(equal(colorTesting))
                    expect(label.textColor).to(equal(.black))
                }
            }
            context("update pokemon in cell function") {
                it("should return cell updated") {
                    waitUntil { done in
                        cell.updatePokemonInCell(pokemonToFetch: result)
                        let cellIdLabelText = cell.idLabel.text
                        done()
                    }

                }
            }
        }
    }
}
