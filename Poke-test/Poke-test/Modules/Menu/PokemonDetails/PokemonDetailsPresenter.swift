//MARK: - PokemonDetailsPresenter
class PokemonDetailsPresenter{
    var view: PokemonDetailsViewDelegate?
    var interactor: PokemonDetailsInteractorDelegate?
    var wireframe: PokemonDetailsWireframeDelegate?
    var cell: PokemonListCellDelegate?
    var tableView: PokemonListViewDelegate?
}


//MARK: - PokemonDetailsPresenterDelegate methods
extension PokemonDetailsPresenter: PokemonDetailsPresenterDelegate{
    
    
    //MARK: - fetchPokemon
    func fetchPokemon(pokemon: Results) {
        interactor?.fetchPokemon(pokemon: pokemon)
    }
    
    
    //MARK: - fetchFavourites
    func fetchFavourites(){
        interactor?.fetchFavouritePokemons()
    }
    
    
    //MARK: - addFavourite
    func addFavourite(pokemon: Results) {
        interactor?.addFavourite(pokemon: pokemon)
    }
    
    
    //MARK: - deleteFavourite
    func deleteFavourite(pokemon: Results) {
        interactor?.deleteFavourite(pokemon: pokemon)
    }
    
    
    //MARK: - openLoginSignUpWindow
    func openLoginSignUpWindow(){
        wireframe?.openLoginSignUpWindow()
    }
}


//MARK: - PokemonDetailsInteractorOutputDelegate
extension PokemonDetailsPresenter: PokemonDetailsInteractorOutputDelegate {
    
    
    //MARK: - didFetchPokemon
    func didFetchPokemon(pokemon: PokemonData) {
        view?.updateDetailsView(pokemon: pokemon)
    }
    
    
    //MARK: - didFailWithError
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
    //MARK: - didGetSelectedPokemon
    func didGetSelectedPokemon(with pokemon: Results) {
        view?.getSelectedPokemon(with: pokemon)
    }
    
    
    //MARK: - didFetchFavourites
    func didFetchFavourites(_ favourites: [Favourites]) {
        view?.updateDetailsViewFavourites(favourites: favourites)
    }
    
    
    //MARK: - didAddFavourite
    func didAddFavourite(pokemon: Results) {
        view?.addFavourite(pokemon: pokemon)
    }
    
    
    //MARK: - didAddFavouriteWithError
    func didAddFavouriteWithError(error: Error?) {
        guard let error = error else {return}
        print(error)
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
