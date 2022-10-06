//
//  PokemonListPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
class PokemonListPresenter {
    var view: PokemonListViewDelegate?
    var interactor: PokemonListInteractorDelegate?
    var wireframe: PokemonListWireframeDelegate?
    var cell: PokemonCellDelegate?
}

extension PokemonListPresenter: PokemonListPresenterDelegate {
    func fetchPokemonList() {
        interactor?.fetchPokemonList()
    }
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        wireframe?.openPokemonDetailsWindow(
            pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }
    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }

    func addFavourite(pokemon: Results) {
        interactor?.addFavourite(pokemon: pokemon)
    }

    func fetchFavourites() {
        interactor?.fetchFavourites()
    }

    func openLoginSignUpWindow() {
        wireframe?.openLoginSignUpWindow()
    }
}

extension PokemonListPresenter: PokemonListInteractorOutputDelegate {
    func didFailWith(error: Error) {
        print(error)
    }
    func didFetchPokemonList(pokemon: PokemonListData) {
        view?.updateTableView(pokemons: pokemon)
    }
    func didFetchType(pokemons: PokemonFilterListData) {
        view?.updateFiltersTableView(pokemons: pokemons)
    }
    func didAddFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }
    func didIsSaved(saved: Bool) {
        print(saved)
    }
    func didFetchFavourites(favourites: [Favourites]) {
        view?.updateFavourites(favourites: favourites)
    }
}
