//
//  PokemonListProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit

protocol PokemonListViewDelegate: AnyObject {
    var presenter: PokemonListPresenterDelegate? {get set}
}

protocol PokemonListWireframeDelegate: AnyObject {
    static func createPokemonListModule() -> UIViewController
}

protocol PokemonListPresenterDelegate: AnyObject {
    var view: PokemonListViewDelegate? {get set}
    var interactor: PokemonListInteractorDelegate? {get set}
    var wireframe: PokemonListWireframeDelegate? {get set}
}

protocol PokemonListInteractorDelegate: AnyObject {
    var presenter: PokemonListInteractorOutputDelegate? {get set}
}

protocol PokemonListInteractorOutputDelegate: AnyObject {

}
