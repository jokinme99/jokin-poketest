//
//  DDBBManagerSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 25/5/22.
//

import Quick
import Nimble
import RealmSwift
@testable import Poke_test

class DDBBManagerSpec: QuickSpec {
    override func spec() {
        var ddbbManager: DDBBManager!
        var pokemonManager: PokemonManager!
        beforeEach {
            ddbbManager = DDBBManager.shared
            pokemonManager = PokemonManager.shared
        }
        describe("Interacting with DDBB") {
            context("delete an get data") {
                it("should delete data from db and the obtained data should be equal to 0") {
                    ddbbManager.removeAll()
                    expect(ddbbManager.get(PokemonListData.self).count).to(equal(0))
                }
            }
            context("save all data and get data") {
                it("should save all data in db and check if it has been correctly added") {
                    waitUntil(timeout: .never) { done in
                        pokemonManager.saveDataOffline = true
                        pokemonManager.fetchList { _, _ in
                            expect(ddbbManager.get(PokemonListData.self).count).notTo(equal(0))
                        }
                        done()
                    }
                }
            }
        }
    }
}
