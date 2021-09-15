//
//  PokemonListPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//
import RealmSwift

class PokemonListPresenter : PokemonListPresenterDelegate {
    var view: PokemonListViewDelegate?
    var interactor: PokemonListInteractorDelegate?
    var wireframe: PokemonListWireframeDelegate?
    var cell: PokemonListCellDelegate?
    func fetchPokemonList() { 
        interactor?.fetchPokemonList()
    }
    func fetchFavourites(){
        interactor?.fetchFavouritePokemons()
    }
    func openPokemonDetail(with selectedPokemon: Results) {
        wireframe?.openPokemonDetailsWindow(with: selectedPokemon)
    }
}

extension PokemonListPresenter: PokemonListInteractorOutputDelegate {
    func didFetchFavourites(favourites: [Results]) {
        cell?.updateCellFavourites(favourites: favourites) // It works
        view?.updateTableViewFavourites() // To reload after editing
    }
    
    func didFailWith(error: Error) {
        print(error)
    }
    
    func didFetchPokemonList(pokemon: PokemonListData) {
        view?.updateTableView(pokemons: pokemon)
    }
}
