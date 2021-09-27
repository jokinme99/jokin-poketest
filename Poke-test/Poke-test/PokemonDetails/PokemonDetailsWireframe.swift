
import UIKit


class PokemonDetailsWireframe : PokemonDetailsWireframeDelegate {
    
    var viewController: UIViewController?
    //MARK: - Method that makes the window(.xib)
    static func createPokemonDetailsModule(with pokemon: Results) -> UIViewController {
        let presenter = PokemonDetailsPresenter()
        let view = PokemonDetailsViewController()
        let wireframe = PokemonDetailsWireframe()
        let interactor = PokemonDetailsInteractor()
        
        
        //presenter.didGetSelectedPokemon(with: pokemon)
        view.selectedPokemon = pokemon // ??
        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
}
