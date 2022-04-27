//
//  PokemonFavouritesProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/11/21.
//
import UIKit

protocol PokemonFavouritesViewDelegate: AnyObject {
    var presenter: PokemonFavouritesPresenterDelegate? {get set}
    func updateTableViewFavourites()
    func updateFavouritesFetchInCell(favourites: [Favourites])
    func updateFiltersTableView(pokemons: PokemonFilterListData)
    func deleteFavourite(pokemon: Results)
}

protocol PokemonFavouritesWireframeDelegate: AnyObject {
    static func createPokemonFavouritesModule() -> UIViewController
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
    func openPokemonListWindow()
}

protocol PokemonFavouritesPresenterDelegate: AnyObject {
    var cell: PokemonCellDelegate? {get set}
    var view: PokemonFavouritesViewDelegate? {get set}
    var interactor: PokemonFavouritesInteractorDelegate? {get set}
    var wireframe: PokemonFavouritesWireframeDelegate? {get set}
    func fetchFavourites()
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
    func openPokemonListWindow()
    func fetchPokemonType(type: String)
    func deleteFavourite(pokemon: Results)
}

protocol PokemonFavouritesInteractorDelegate: AnyObject {
    var presenter: PokemonFavouritesInteractorOutputDelegate? {get set}
    func fetchFavouritePokemons()
    func fetchPokemonType(type:String)
    func deleteFavourite(pokemon: Results)
}

protocol PokemonFavouritesInteractorOutputDelegate: AnyObject {
    func didFailWith(error: Error)
    func didFetchFavourites(favourites: [Favourites])
    func didFetchType(pokemons: PokemonFilterListData)
    func didDeleteFavourite(pokemon: Results)
    func didIsSaved(saved: Bool)
    func didDeleteFavouriteWithError(error: Error?)
}
