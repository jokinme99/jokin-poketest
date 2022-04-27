//
//  PokemonDetailsPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import UIKit

class PokemonDetailsPresenter{
    
    var view: PokemonDetailsViewDelegate?
    var interactor: PokemonDetailsInteractorDelegate?
    var wireframe: PokemonDetailsWireframeDelegate?
    var cell: PokemonCellDelegate?
    var tableView: PokemonListViewDelegate?
    
}

extension PokemonDetailsPresenter: PokemonDetailsPresenterDelegate{

    func fetchPokemon(pokemon: Results) {
        interactor?.fetchPokemon(pokemon: pokemon)
    }
    
    func fetchFavourites(){
        interactor?.fetchFavouritePokemons()
    }
    
    func addFavourite(pokemon: Results) {
        interactor?.addFavourite(pokemon: pokemon)
    }

    func deleteFavourite(pokemon: Results) {
        interactor?.deleteFavourite(pokemon: pokemon)
    }

    func openLoginSignUpWindow(){
        wireframe?.openLoginSignUpWindow()
    }
    
    func openARKitView(){
        wireframe?.openARKitView()
    }
}

extension PokemonDetailsPresenter: PokemonDetailsInteractorOutputDelegate {

    func didFetchPokemon(pokemon: PokemonData) {
        view?.updateDetailsView(pokemon: pokemon)
    }

    func didFailWithError(error: Error) {
        print(error)
    }

    func didGetSelectedPokemon(with pokemon: Results) {
        view?.getSelectedPokemon(with: pokemon)
    }

    func didFetchFavourites(_ favourites: [Favourites]) {
        view?.updateDetailsViewFavourites(favourites: favourites)
    }

    func didAddFavourite(pokemon: Results) {
        view?.addFavourite(pokemon: pokemon)
    }

    func didAddFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
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
