
import UIKit

class PokemonDetailsWireframe : PokemonDetailsWireframeDelegate {
    
    var viewController: UIViewController?
    
    //MARK: - Method that make the window(.xib)
    static func createPokemonDetailsModule(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) -> UIViewController {
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
}