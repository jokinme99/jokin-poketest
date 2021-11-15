//
//  PokemonFavouritesProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 12/11/21.
//

import UIKit
//No fetching of the pokemonListData only favourites 
//No need to do PokemonListCellDelegate methods
protocol PokemonFavouritesViewDelegate: AnyObject {
    var presenter: PokemonFavouritesPresenterDelegate? {get set}
    func updateTableViewFavourites()
    func updateFavouritesFetchInCell(favourites: [Favourites])
    func updateFiltersTableView(pokemons: PokemonFilterListData)
}

protocol PokemonFavouritesWireframeDelegate: AnyObject {
    static func createPokemonFavouritesModule() -> UIViewController
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
}

protocol PokemonFavouritesPresenterDelegate: AnyObject {
    var cell: PokemonListCellDelegate? {get set}
    var view: PokemonFavouritesViewDelegate? {get set}
    var interactor: PokemonFavouritesInteractorDelegate? {get set}
    var wireframe: PokemonFavouritesWireframeDelegate? {get set}
    func fetchFavourites()
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func fetchPokemonType(type: String)
}

protocol PokemonFavouritesInteractorDelegate: AnyObject {
    var presenter: PokemonFavouritesInteractorOutputDelegate? {get set}
    func fetchFavouritePokemons()
    func fetchPokemonType(type:String)
}

protocol PokemonFavouritesInteractorOutputDelegate: AnyObject {
    func didFailWith(error: Error)
    func didFetchFavourites(favourites: [Favourites])
    func didFetchType(pokemons: PokemonFilterListData)
}
