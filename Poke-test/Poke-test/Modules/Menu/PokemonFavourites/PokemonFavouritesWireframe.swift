//
//  PokemonFavouritesWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 12/11/21.
//

import UIKit

class PokemonFavouritesWireframe : PokemonFavouritesWireframeDelegate {

    var viewController: UIViewController?

    static func createPokemonFavouritesModule() -> UIViewController {
        let presenter = PokemonFavouritesPresenter()
        let view = PokemonFavouritesViewController()
        let wireframe = PokemonFavouritesWireframe()
        let interactor = PokemonFavouritesInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        let detailModule = PokemonDetailsWireframe.createPokemonDetailsModule(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }
}
