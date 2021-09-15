//
//  PokemonDetailsProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit
import RealmSwift

protocol PokemonDetailsViewDelegate: AnyObject {
    var presenter: PokemonDetailsPresenterDelegate? {get set}
    func updateDetailsView(pokemon: PokemonData)
    func updateDetailsViewFavourites(favourites: [Results])//When fetching favourites
    func editFavourites(pokemon: Results)
    func getSelectedPokemon(with pokemon: Results)
}

protocol PokemonDetailsWireframeDelegate: AnyObject {
    static func createPokemonDetailsModule(with pokemon: Results) -> UIViewController
}

protocol PokemonDetailsPresenterDelegate: AnyObject {
    var view: PokemonDetailsViewDelegate? {get set}
    var interactor: PokemonDetailsInteractorDelegate? {get set}
    var wireframe: PokemonDetailsWireframeDelegate? {get set}
    func fetchPokemon(pokemon: Results)
    func fetchFavourites()//Check if the pokemon is in the fetched favourites
    func editFavourites(pokemon: Results)
}

protocol PokemonDetailsInteractorDelegate: AnyObject {
    var presenter: PokemonDetailsInteractorOutputDelegate? {get set}
    func fetchPokemon(pokemon: Results)
    func fetchFavouritePokemons()
    func editFavourites(pokemon: Results)
}

protocol PokemonDetailsInteractorOutputDelegate: AnyObject {
    func didFetchPokemon(pokemon: PokemonData)
    func didFailWithError(error: Error)
    func didFetchFavourites(_ favourites: [Results])
    func didEditFavourites(pokemon: Results)
    func didSaveFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
    func didDeleteFavouriteWithError(error: Error?)
    func didGetSelectedPokemon(with pokemon: Results)
}
