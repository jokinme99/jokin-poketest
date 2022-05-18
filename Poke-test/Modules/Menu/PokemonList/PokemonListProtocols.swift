//
//  PokemonListProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import UIKit

protocol PokemonListViewDelegate: AnyObject {
    var presenter: PokemonListPresenterDelegate? {get set}
    func updateTableView(pokemons: PokemonListData)
    func updateFiltersTableView(pokemons: PokemonFilterListData)
    func updateTableView()
    func updateFavourites(favourites: [Favourites])
}

protocol PokemonListWireframeDelegate: AnyObject {
    static func createPokemonListModule() -> UIViewController
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
}

protocol PokemonListPresenterDelegate: AnyObject {
    var cell: PokemonCellDelegate? {get set}
    var view: PokemonListViewDelegate? {get set}
    var interactor: PokemonListInteractorDelegate? {get set}
    var wireframe: PokemonListWireframeDelegate? {get set}
    func fetchPokemonList()
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func fetchPokemonType(type: String)
    func addFavourite(pokemon: Results)
    func fetchFavourites()
    func openLoginSignUpWindow()
}

protocol PokemonListInteractorDelegate: AnyObject {
    var presenter: PokemonListInteractorOutputDelegate? {get set}
    func fetchPokemonList()
    func fetchPokemonType(type:String)
    func addFavourite(pokemon: Results)
    func fetchFavourites()
}

protocol PokemonListInteractorOutputDelegate: AnyObject {
    func didFetchPokemonList(pokemon: PokemonListData)
    func didFailWith(error: Error)
    func didFetchType(pokemons: PokemonFilterListData)
    func didAddFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
    func didFetchFavourites(favourites: [Favourites])
}

