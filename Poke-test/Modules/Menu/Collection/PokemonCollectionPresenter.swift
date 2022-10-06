//
//  PokemonCollectionPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
class PokemonCollectionPresenter {
    var view: PokemonCollectionViewDelegate?
    var interactor: PokemonCollectionInteractorDelegate?
    var wireframe: PokemonCollectionWireframeDelegate?
}

extension PokemonCollectionPresenter: PokemonCollectionPresenterDelegate {

    func fetchPokemonList() {
        self.interactor?.fetchPokemonList()
    }

    func fetchFavourites() {
        self.interactor?.fetchFavourites()
    }

    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }

    func addFavourite(pokemon: Results) {
        self.interactor?.addFavourite(pokemon: pokemon)
    }

    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        self.wireframe?.openPokemonDetailsWindow(
            pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }

    func openLoginSignUpWindow() {
        self.wireframe?.openLoginSignUpWindow()
    }
}

extension PokemonCollectionPresenter: PokemonCollectionInteractorOutputDelegate {
    func didFetchPokemonList(pokemon: PokemonListData) {
        self.view?.updateListCollectionView(pokemons: pokemon)
    }

    func didFetchFavourites(favourites: [Favourites]) {
        self.view?.updateFavouritesCollectionView(favourites: favourites)
        self.view?.updateCollectionView()
    }

    func didFetchType(pokemons: PokemonFilterListData) {
        view?.updateFiltersCollectionView(pokemons: pokemons)
    }

    func didFailWith(error: Error) {
        print(error)
    }

    func didAddFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }

    func didIsSaved(saved: Bool) {
        print(saved)
    }
}
