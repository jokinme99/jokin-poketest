//
//  PokemonDetailsPresenter.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

class PokemonDetailsPresenter : PokemonDetailsPresenterDelegate {
    var view: PokemonDetailsViewDelegate?
    var interactor: PokemonDetailsInteractorDelegate?
    var wireframe: PokemonDetailsWireframeDelegate?
}

extension PokemonDetailsPresenter: PokemonDetailsInteractorOutputDelegate {

}
