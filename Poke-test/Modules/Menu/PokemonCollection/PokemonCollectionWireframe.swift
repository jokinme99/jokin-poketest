//
//  PokemonCollectionWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import UIKit

class PokemonCollectionWireframe{
    
    var viewController: UIViewController?
    
}

extension PokemonCollectionWireframe: PokemonCollectionWireframeDelegate{

    static func createPokemonCollectionModule() -> UIViewController {
        let presenter = PokemonCollectionPresenter()
        let view = PokemonCollectionViewController()
        let wireframe = PokemonCollectionWireframe()
        let interactor = PokemonCollectionInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        wireframe.viewController = view
        
        return view
    }

    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        let detailModule = PokemonDetailsWireframe.createPokemonDetailsModule(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }

    func openLoginSignUpWindow(){
        let loginSignUpModule = LoginOrSignUpWireframe.createLoginOrSignUpModule()
        let navigation = UINavigationController(rootViewController: loginSignUpModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
