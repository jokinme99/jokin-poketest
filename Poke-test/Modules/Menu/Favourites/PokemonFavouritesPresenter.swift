//
//  PokemonFavouritesPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/11/21.
//
class PokemonFavouritesPresenter {
    var view: PokemonFavouritesViewDelegate?
    var interactor: PokemonFavouritesInteractorDelegate?
    var wireframe: PokemonFavouritesWireframeDelegate?
    var cell: PokemonCellDelegate?
}

extension PokemonFavouritesPresenter: PokemonFavouritesPresenterDelegate {

    func fetchFavourites() {
        interactor?.fetchFavouritePokemons()
    }

    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        wireframe?.openPokemonDetailsWindow(
            pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }

    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }

    func deleteFavourite(pokemon: Results) {
        interactor?.deleteFavourite(pokemon: pokemon)
    }

    func openLoginSignUpWindow() {
        wireframe?.openLoginSignUpWindow()
    }

    func openPokemonListWindow() {
        wireframe?.openPokemonListWindow()
    }
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

    func didDeleteFavourite(pokemon: Results) {
        view?.deleteFavourite(pokemon: pokemon)
    }

    func didDeleteFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }

    func didIsSaved(saved: Bool) {
        print(saved)
    }
}
