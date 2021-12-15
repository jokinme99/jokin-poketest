
import UIKit


//MARK: - PokemonFavouritesWireframe
class PokemonFavouritesWireframe{
    var viewController: UIViewController?
}


//MARK: - PokemonFavouritesWireframeDelegate methods
extension PokemonFavouritesWireframe: PokemonFavouritesWireframeDelegate{
    
    
    //MARK: - createPokemonFavouritesModule
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
    
    
    //MARK: - openPokemonListWindow
    func openPokemonListWindow(){
        let mainTabBarModule = MainTabBarWireframe.createMainTabBarModule()
        let navigation = UINavigationController(rootViewController: mainTabBarModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
