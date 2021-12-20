//MARK: - PokemonCollectionPresenter
class PokemonCollectionPresenter{
    var view: PokemonCollectionViewDelegate?
    var interactor: PokemonCollectionInteractorDelegate?
    var wireframe: PokemonCollectionWireframeDelegate?
}


//MARK: - PokemonCollectionPresenterDelegate methods
extension PokemonCollectionPresenter: PokemonCollectionPresenterDelegate{
    
    
    //MARK: - fetchPokemonList
    func fetchPokemonList() {
        self.interactor?.fetchPokemonList()
    }
    
    
    //MARK: - fetchFavourites
    func fetchFavourites() {
        self.interactor?.fetchFavourites()
    }
    
    
    //MARK: - fetchPokemonType
    func fetchPokemonType(type: String) {
        interactor?.fetchPokemonType(type: type)
    }
    
    
    //MARK: - addFavourite
    func addFavourite(pokemon: Results) {
        self.interactor?.addFavourite(pokemon: pokemon)
    }
    
    
    //MARK: - openPokemonDetail
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) {
        self.wireframe?.openPokemonDetailsWindow(pokemon: pokemon, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }
    
    
    //MARK: - openLoginSignUpWindow
    func openLoginSignUpWindow() {
        self.wireframe?.openLoginSignUpWindow()
    }
}


//MARK: - PokemonCollectionInteractorOutputDelegate
extension PokemonCollectionPresenter: PokemonCollectionInteractorOutputDelegate {
    
    
    //MARK: - didFetchPokemonList
    func didFetchPokemonList(pokemon: PokemonListData) {
        self.view?.updateListCollectionView(pokemons: pokemon)
    }
    
    
    //MARK: - didFetchFavourites
    func didFetchFavourites(favourites: [Favourites]) {
        self.view?.updateFavouritesCollectionView(favourites: favourites)
        self.view?.updateCollectionView()
    }
    
    
    //MARK: - didFetchType
    func didFetchType(pokemons: PokemonFilterListData) {
        view?.updateFiltersCollectionView(pokemons: pokemons)
    }
    
    
    //MARK: - didFailWithError
    func didFailWith(error: Error) {
        print(error)
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
}
