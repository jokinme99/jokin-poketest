
class PokemonListPresenter : PokemonListPresenterDelegate {
    var view: PokemonListViewDelegate?
    var interactor: PokemonListInteractorDelegate?
    var wireframe: PokemonListWireframeDelegate?
    var cell: PokemonListCellDelegate?
    
    //MARK: - These methods call the method that do the functionality
    
    func fetchPokemonList() { 
        interactor?.fetchPokemonList()
    }
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        wireframe?.openPokemonDetailsWindow(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }
    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }
    func addFavourite(pokemon: Results) {
        interactor?.addFavourite(pokemon: pokemon)
    }
    func fetchFavourites() {
        interactor?.fetchFavourites()
    }
    func openLoginSignUpWindow(){
        wireframe?.openLoginSignUpWindow()
    }
}

//MARK: - Methods that return the results from the functionality methods
extension PokemonListPresenter: PokemonListInteractorOutputDelegate {
    func didFailWith(error: Error) {
        print(error)
    }
    func didFetchPokemonList(pokemon: PokemonListData) {
        view?.updateTableView(pokemons: pokemon)
    }
    func didFetchType(pokemons: PokemonFilterListData) {
        view?.updateFiltersTableView(pokemons: pokemons)
    }
//    func didAddFavourite(pokemon: Results) {
//        view?.addFavourite(pokemon: pokemon)
//    }
    func didAddFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }
    func didIsSaved(saved: Bool) {
        print(saved)
    }
    func didFetchFavourites(favourites: [Favourites]) {
        view?.updateTableView()
        view?.updateFavourites(favourites: favourites)
    }
    
}
