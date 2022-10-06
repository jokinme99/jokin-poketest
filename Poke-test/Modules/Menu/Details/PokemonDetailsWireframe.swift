//
//  PokemonDetailsWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import UIKit

class PokemonDetailsWireframe {
    var viewController: UIViewController?
}

extension PokemonDetailsWireframe: PokemonDetailsWireframeDelegate {

    static func createPokemonDetailsModule(
        pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) -> UIViewController {
        let presenter = PokemonDetailsPresenter()
        let view = PokemonDetailsViewController()
        let wireframe = PokemonDetailsWireframe()
        let interactor = PokemonDetailsInteractor()
        view.selectedPokemon = pokemon
        view.nextPokemon = nextPokemon
        view.previousPokemon = previousPokemon
        view.filtered = filtered
        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }

    func openLoginSignUpWindow() {
        let loginSignUpModule = LoginOrSignUpWireframe.createLoginOrSignUpModule()
        let navigation = UINavigationController(rootViewController: loginSignUpModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

    func openARKitView() {
        let arkitModule = ARKitWireframe.createARKitModule()
        viewController?.navigationController?.pushViewController(arkitModule, animated: true)
    }
}
