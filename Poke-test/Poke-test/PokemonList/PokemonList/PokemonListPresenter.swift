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
    func fetchFavourites(){ //It works but not in the cell!
        interactor?.fetchFavouritePokemons()
    }
    func openPokemonDetail(with selectedPokemon: Results) {
        wireframe?.openPokemonDetailsWindow(with: selectedPokemon)
    }
    func fetchPokemonDetails(pokemon: Results) {
        interactor?.fetchPokemonDetails(pokemon: pokemon)
    }
}

extension PokemonListPresenter: PokemonListInteractorOutputDelegate {
    func didFetchFavourites(favourites: [Results]) {
        view?.updateTableViewFavourites()
        view?.updateFavouritesFetchInCell(favourites: favourites)
        
    }
    
    func didFailWith(error: Error) {
        print(error)
    }
    
    func didFetchPokemonList(pokemon: PokemonListData) {
        view?.updateTableView(pokemons: pokemon)
    }
    func didFetchPokemonDetails(pokemon: PokemonData) {
        view?.updateDetailsFetchInCell(pokemon: pokemon)
        //cell?.updatePokemonCellData(pokemon: pokemon) //It works!

    }
}
