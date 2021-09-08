//
//  PokemonDetailsProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit

protocol PokemonDetailsViewDelegate: AnyObject {
    var presenter: PokemonDetailsPresenterDelegate? {get set}
}

protocol PokemonDetailsWireframeDelegate: AnyObject {
    static func createPokemonDetailsModule() -> UIViewController
}

protocol PokemonDetailsPresenterDelegate: AnyObject {
    var view: PokemonDetailsViewDelegate? {get set}
    var interactor: PokemonDetailsInteractorDelegate? {get set}
    var wireframe: PokemonDetailsWireframeDelegate? {get set}
}

protocol PokemonDetailsInteractorDelegate: AnyObject {
    var presenter: PokemonDetailsInteractorOutputDelegate? {get set}
}

protocol PokemonDetailsInteractorOutputDelegate: AnyObject {

}
