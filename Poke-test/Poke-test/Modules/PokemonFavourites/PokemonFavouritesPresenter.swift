//
//  PokemonFavouritesPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 12/11/21.
//

class PokemonFavouritesPresenter : PokemonFavouritesPresenterDelegate {
    func fetchFavourites() {
        interactor?.fetchFavouritePokemons()
    }
    
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        wireframe?.openPokemonDetailsWindow(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }
    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }
    
    var view: PokemonFavouritesViewDelegate?
    var interactor: PokemonFavouritesInteractorDelegate?
    var wireframe: PokemonFavouritesWireframeDelegate?
    var cell: PokemonListCellDelegate?
}

extension PokemonFavouritesPresenter: PokemonFavouritesInteractorOutputDelegate {
    func didFailWith(error: Error) {
        print(error)
    }
    
    func didFetchFavourites(favourites: [Favourites]) {
        view?.updateTableViewFavourites()
        view?.updateFavouritesFetchInCell(favourites: favourites)
    }
    
    func didFetchType(pokemons: PokemonFilterListData) {
        view?.updateFiltersTableView(pokemons: pokemons)
    }
}
