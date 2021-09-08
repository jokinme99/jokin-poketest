//
//  PokemonListPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

class PokemonListPresenter : PokemonListPresenterDelegate {
    var view: PokemonListViewDelegate?
    var interactor: PokemonListInteractorDelegate?
    var wireframe: PokemonListWireframeDelegate?
}

extension PokemonListPresenter: PokemonListInteractorOutputDelegate {

}
