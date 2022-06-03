//
//  PokemonFavouritesWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/11/21.
//
import UIKit

class PokemonFavouritesWireframe {
    var viewController: UIViewController?
}

extension PokemonFavouritesWireframe: PokemonFavouritesWireframeDelegate {

    static func createPokemonFavouritesModule() -> UIViewController {
        let presenter = PokemonFavouritesPresenter()
        let view = PokemonFavouritesViewController()
        let wireframe = PokemonFavouritesWireframe()
        let interactor = PokemonFavouritesInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
    func openPokemonDetailsWindow(
        pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        let detailModule = PokemonDetailsWireframe.createPokemonDetailsModule(
            pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }

    func openLoginSignUpWindow() {
        let loginSignUpModule = LoginOrSignUpWireframe.createLoginOrSignUpModule()
        let navigation = UINavigationController(rootViewController: loginSignUpModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

    func openPokemonListWindow() {
        let mainTabBarModule = MainTabBarWireframe.createMainTabBarModule()
        let navigation = UINavigationController(rootViewController: mainTabBarModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
