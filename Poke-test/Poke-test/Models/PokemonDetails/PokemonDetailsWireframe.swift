//
//  PokemonDetailsWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit

class PokemonDetailsWireframe : PokemonDetailsWireframeDelegate {

    var viewController: UIViewController?

    static func createPokemonDetailsModule() -> UIViewController {
        let presenter = PokemonDetailsPresenter()
        let view = PokemonDetailsViewController()
        let wireframe = PokemonDetailsWireframe()
        let interactor = PokemonDetailsInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
}
