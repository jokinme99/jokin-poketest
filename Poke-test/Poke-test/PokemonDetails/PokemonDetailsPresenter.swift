
import RealmSwift

class PokemonDetailsPresenter : PokemonDetailsPresenterDelegate {
    
    var view: PokemonDetailsViewDelegate?
    var interactor: PokemonDetailsInteractorDelegate?
    var wireframe: PokemonDetailsWireframeDelegate?
    var cell: PokemonListCellDelegate?
    var tableView: PokemonListViewDelegate?
    
    //MARK: - These methods call the method that do the functionality
    
    func fetchPokemon(pokemon: Results) {
        interactor?.fetchPokemon(pokemon: pokemon)
    }
    func fetchFavourites(){
        interactor?.fetchFavouritePokemons()
    }
    func addFavourite(pokemon: Results) {
        interactor?.addFavourite(pokemon: pokemon)
    }
    
    func deleteFavourite(pokemon: Results) {
        interactor?.deleteFavourite(pokemon: pokemon)
    }
}

extension PokemonDetailsPresenter: PokemonDetailsInteractorOutputDelegate {
    //MARK: - Methods that return the results from the functionality methods
    func didFetchPokemon(pokemon: PokemonData) {
        view?.updateDetailsView(pokemon: pokemon)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    func didGetSelectedPokemon(with pokemon: Results) {
        view?.getSelectedPokemon(with: pokemon)//It works
    }
    
    func didFetchFavourites(_ favourites: [Results]) {
        view?.updateDetailsViewFavourites(favourites: favourites)
    }
    func didAddFavourite(pokemon: Results) {
        view?.addFavourite(pokemon: pokemon)
    }
    func didAddFavouriteWithError(error: Error?) {
        print(error!)
    }
    func didDeleteFavourite(pokemon: Results) {
        view?.deleteFavourite(pokemon: pokemon)
    }
    func didDeleteFavouriteWithError(error: Error?) {
        print(error!)
    }
    
    func didIsSaved(saved: Bool) {
        print(saved)
    }
}
