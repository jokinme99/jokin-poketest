//MARK: - PokemonListPresenter
class PokemonListPresenter{
    var view: PokemonListViewDelegate?
    var interactor: PokemonListInteractorDelegate?
    var wireframe: PokemonListWireframeDelegate?
    var cell: PokemonCellDelegate?
}



//MARK: - PokemonListPresenterDelegate methods
extension PokemonListPresenter: PokemonListPresenterDelegate{
    
    
    //MARK: - fetchPokemonList
    func fetchPokemonList() {
        interactor?.fetchPokemonList()
    }
    
    
    //MARK: - openPokemonDetail
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        wireframe?.openPokemonDetailsWindow(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }
    
    
    //MARK: - fetchPokemonType
    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }
    
    
    //MARK: - addFavourite
    func addFavourite(pokemon: Results) {
        interactor?.addFavourite(pokemon: pokemon)
    }
    
    
    //MARK: - fetchFavourites
    func fetchFavourites() {
        interactor?.fetchFavourites()
    }
    
    
    //MARK: - openLoginSignUpWindow
    func openLoginSignUpWindow(){
        wireframe?.openLoginSignUpWindow()
    }}


//MARK: - PokemonListInteractorOutputDelegate methods
extension PokemonListPresenter: PokemonListInteractorOutputDelegate {
    
    
    //MARK: - didFailWith
    func didFailWith(error: Error) {
        print(error)
    }
    
    
    //MARK: - didFetchPokemonList
    func didFetchPokemonList(pokemon: PokemonListData) {
        view?.updateTableView(pokemons: pokemon)
    }
    
    
    //MARK: - didFetchType
    func didFetchType(pokemons: PokemonFilterListData) {
        view?.updateFiltersTableView(pokemons: pokemons)
    }
    
    
    //MARK: - didAddFavouriteWithError
    func didAddFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }
    
    
    //MARK: - didIsSaved
    func didIsSaved(saved: Bool) {
        print(saved)
    }
    
    
    //MARK: - didFetchFavourites
    func didFetchFavourites(favourites: [Favourites]) {
        view?.updateTableView()
        view?.updateFavourites(favourites: favourites)
    }
    
}
