//
//  PokemonDetailsPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import RealmSwift

class PokemonDetailsPresenter : PokemonDetailsPresenterDelegate {
    var view: PokemonDetailsViewDelegate?
    var interactor: PokemonDetailsInteractorDelegate?
    var wireframe: PokemonDetailsWireframeDelegate?
    var cell: PokemonListCellDelegate?
    func fetchPokemon(pokemon: Results) {
        interactor?.fetchPokemon(pokemon: pokemon)
    }
    func fetchFavourites(){
        interactor?.fetchFavouritePokemons()
    }
    func editFavourites(pokemon: Results) {
        interactor?.editFavourites(pokemon: pokemon)
    }
}

extension PokemonDetailsPresenter: PokemonDetailsInteractorOutputDelegate {
    func didSaveFavouriteWithError(error: Error?) {
        print(error!)
    }
    
    func didIsSaved(saved: Bool) {
        print(saved)
    }
    
    func didDeleteFavouriteWithError(error: Error?) {
        print(error!)
    }
    
    func didFetchPokemon(pokemon: PokemonData) {
        view?.updateDetailsView(pokemon: pokemon)
        cell?.updatePokemonCellData(pokemon: pokemon)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didFetchFavourites(_ favourites: [Results]) {
        view?.updateDetailsViewFavourites(favourites: favourites)
    }
    func didEditFavourites(pokemon:Results){
        view?.editFavourites(pokemon: pokemon)
    }
    func didGetSelectedPokemon(with pokemon: Results) {
        view?.getSelectedPokemon(with: pokemon)//It works
    }
    

}
