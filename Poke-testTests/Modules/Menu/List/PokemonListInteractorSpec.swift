//
//  PokemonListInteractorSpec.swift
//  Poke-testTests
//
//  Created by Jokin Egia on 20/6/22.
//  Copyright © 2022 Batura-Mobile. All rights reserved.
//

import Quick
import Nimble
import FirebaseDatabase
import FirebaseAuth
@testable import Poke_test

// Should the fetch methods be tested?

class PokemonListInteractorSpec: QuickSpec {
    override func spec() {
        var interactor: PokemonListInteractor!
        beforeEach {
            interactor = PokemonListInteractor()
        }
        describe("Testing interactor") {
            context("objects") {
                it("should return the reference") {
                    let interactorRef = interactor.ref
                    let comparationRef = Database.database().reference()
                    expect(interactorRef.url).to(equal(comparationRef.url))
                }
                it("should return nil or value") {
                    let interactorUser = interactor.user
                    if let interactorUser = interactorUser {
                        expect(interactorUser.email).to(equal(Auth.auth().currentUser?.email))
                    } else {
                        expect(interactorUser).to(beNil())
                    }
                }
            }
        }
    }
}
