
import RealmSwift

class PokemonListPresenter : PokemonListPresenterDelegate {
    var view: PokemonListViewDelegate?
    var interactor: PokemonListInteractorDelegate?
    var wireframe: PokemonListWireframeDelegate?
    var cell: PokemonListCellDelegate?
    
    //MARK: - These methods call the method that do the functionality
    
    func fetchPokemonList() { 
        interactor?.fetchPokemonList()
    }
    func fetchFavourites(){ 
        interactor?.fetchFavouritePokemons()
    }
    func openPokemonDetail(with selectedPokemon: Results) {
        wireframe?.openPokemonDetailsWindow(with: selectedPokemon)
    }
}


extension PokemonListPresenter: PokemonListInteractorOutputDelegate {
    //MARK: - Methods that return the results from the functionality methods
    
    func didFetchFavourites(favourites: [Results]) {
        view?.updateTableViewFavourites()
        view?.updateFavouritesFetchInCell(favourites: favourites)
    }
    
    func didFailWith(error: Error) {
        print(error)
    }
    
    func didFetchPokemonList(pokemon: PokemonListData) {
        view?.updateTableView(pokemons: pokemon)
    }
    
}
