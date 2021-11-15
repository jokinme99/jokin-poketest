
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
    
}
