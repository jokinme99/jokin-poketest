
//MARK: - PokemonFavouritesPresenter
class PokemonFavouritesPresenter{
    var view: PokemonFavouritesViewDelegate?
    var interactor: PokemonFavouritesInteractorDelegate?
    var wireframe: PokemonFavouritesWireframeDelegate?
    var cell: PokemonCellDelegate?
}


//MARK: - PokemonFavouritesPresenterDelegate
extension PokemonFavouritesPresenter: PokemonFavouritesPresenterDelegate{
    
    
    //MARK: - fetchFavourites
    func fetchFavourites() {
        interactor?.fetchFavouritePokemons()
    }
    
    
    //MARK: - openPokemonDetail
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        wireframe?.openPokemonDetailsWindow(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }
    
    
    //MARK: - fetchPokemonType
    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }
    
    
    //MARK: - deleteFavourite
    func deleteFavourite(pokemon: Results) {
        interactor?.deleteFavourite(pokemon: pokemon)
    }
    
    
    //MARK: - openLoginSignUpWindow
    func openLoginSignUpWindow(){
        wireframe?.openLoginSignUpWindow()
    }
    
    
    //MARK: - openPokemonListWindow
    func openPokemonListWindow(){
        wireframe?.openPokemonListWindow()
    }
}


//MARK: - PokemonFavouritesInteractorOutputDelegate
extension PokemonFavouritesPresenter: PokemonFavouritesInteractorOutputDelegate {
    
    
    //MARK: - didFailWith
    func didFailWith(error: Error) {
        print(error)
    }
    
    
    //MARK: - didFetchFavourites
    func didFetchFavourites(favourites: [Favourites]) {
        view?.updateTableViewFavourites()
        view?.updateFavouritesFetchInCell(favourites: favourites)
    }
    
    
    //MARK: - didFetchType
    func didFetchType(pokemons: PokemonFilterListData) {
        view?.updateFiltersTableView(pokemons: pokemons)
    }
    
    
    //MARK: - didDeleteFavourite
    func didDeleteFavourite(pokemon: Results) {
        view?.deleteFavourite(pokemon: pokemon)
    }
    
    
    //MARK: - didDeleteFavouriteWithError
    func didDeleteFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }
    
    
    //MARK: - didIsSaved
    func didIsSaved(saved: Bool) {
        print(saved)
    }
}
