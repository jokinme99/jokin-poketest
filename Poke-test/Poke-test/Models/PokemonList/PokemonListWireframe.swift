//
//  PokemonListWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit

class PokemonListWireframe : PokemonListWireframeDelegate {

    var viewController: UIViewController?

    static func createPokemonListModule() -> UIViewController {
        let presenter = PokemonListPresenter()
        let view = PokemonListViewController()
        let wireframe = PokemonListWireframe()
        let interactor = PokemonListInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
}
