
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
    func openLoginSignUpWindow(){
        wireframe?.openLoginSignUpWindow()
    }
}

//MARK: - Methods that return the results from the functionality methods
extension PokemonDetailsPresenter: PokemonDetailsInteractorOutputDelegate {
    func didFetchPokemon(pokemon: PokemonData) {
        view?.updateDetailsView(pokemon: pokemon)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    func didGetSelectedPokemon(with pokemon: Results) {
        view?.getSelectedPokemon(with: pokemon)
    }
    func didFetchFavourites(_ favourites: [Favourites]) {
        view?.updateDetailsViewFavourites(favourites: favourites)
    }
    func didAddFavourite(pokemon: Results) {
        view?.addFavourite(pokemon: pokemon)
    }
    func didAddFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }
    func didDeleteFavourite(pokemon: Results) {
        view?.deleteFavourite(pokemon: pokemon)
    }
    func didDeleteFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
    }
    func didIsSaved(saved: Bool) {
        print(saved)
    }
}
