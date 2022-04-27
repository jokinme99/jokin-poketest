//
//  PokemonDetailsProtocol.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import UIKit

protocol PokemonDetailsViewDelegate: AnyObject {
    var presenter: PokemonDetailsPresenterDelegate? {get set}
    func updateDetailsView(pokemon: PokemonData)
    func updateDetailsViewFavourites(favourites: [Favourites])
    func addFavourite(pokemon: Results)
    func deleteFavourite(pokemon: Results)
    func getSelectedPokemon(with pokemon: Results)
}

protocol PokemonDetailsWireframeDelegate: AnyObject {
    static func createPokemonDetailsModule(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) -> UIViewController
    func openLoginSignUpWindow()
    func openARKitView()
}

protocol PokemonDetailsPresenterDelegate: AnyObject {
    var view: PokemonDetailsViewDelegate? {get set}
    var interactor: PokemonDetailsInteractorDelegate? {get set}
    var wireframe: PokemonDetailsWireframeDelegate? {get set}
    func fetchPokemon(pokemon: Results)
    func fetchFavourites()
    func addFavourite(pokemon: Results)
    func deleteFavourite(pokemon: Results)
    func openLoginSignUpWindow()
    func openARKitView()
}

protocol PokemonDetailsInteractorDelegate: AnyObject {
    var presenter: PokemonDetailsInteractorOutputDelegate? {get set}
    func fetchPokemon(pokemon: Results)
    func fetchFavouritePokemons()
    func addFavourite(pokemon: Results)
    func deleteFavourite(pokemon: Results)
}

protocol PokemonDetailsInteractorOutputDelegate: AnyObject {
    func didFetchPokemon(pokemon: PokemonData)
    func didFailWithError(error: Error)
    func didFetchFavourites(_ favourites: [Favourites])
    func didAddFavourite(pokemon: Results)
    func didAddFavouriteWithError(error: Error?)
    func didDeleteFavourite(pokemon: Results)
    func didDeleteFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
    func didGetSelectedPokemon(with pokemon: Results)
}
