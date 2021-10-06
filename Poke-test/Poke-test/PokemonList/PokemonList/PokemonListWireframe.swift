
import UIKit


class PokemonListWireframe : PokemonListWireframeDelegate {
    
    
    var viewController: UIViewController?
    //MARK: - Method that makes the window(.xib)
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
    //MARK: - Method that opens the detailsViewController .xib
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results) {
        let detailModule = PokemonDetailsWireframe.createPokemonDetailsModule(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }
    
}
