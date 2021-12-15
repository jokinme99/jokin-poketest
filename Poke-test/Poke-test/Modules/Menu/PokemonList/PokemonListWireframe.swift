
import UIKit

//MARK: - PokemonListWireframe
class PokemonListWireframe{
    var viewController: UIViewController?
}


//MARK: - PokemonListWireframeDelegate methods
extension PokemonListWireframe: PokemonListWireframeDelegate{
    
    
    //MARK: - createPokemonListModule
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
    
    
    //MARK: - openPokemonDetailsWindow
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        let detailModule = PokemonDetailsWireframe.createPokemonDetailsModule(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
        viewController?.navigationController?.pushViewController(detailModule, animated: true)
    }
    
    
    //MARK: - openLoginSignUpWindow
    func openLoginSignUpWindow(){
        let loginSignUpModule = LoginOrSignUpWireframe.createLoginOrSignUpModule()
        let navigation = UINavigationController(rootViewController: loginSignUpModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
