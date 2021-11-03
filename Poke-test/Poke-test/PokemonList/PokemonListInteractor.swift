
class PokemonListInteractor : PokemonListInteractorDelegate{
    var presenter: PokemonListInteractorOutputDelegate?
    var view: PokemonListViewDelegate?
    
    //MARK: - Methods that do the functionality
    func fetchPokemonList() {
        PokemonManager.shared.fetchList { pokemonList, error in
            if let error = error {
                self.presenter?.didFailWith(error: error)
            } else {
                self.presenter?.didFetchPokemonList(pokemon: pokemonList!)
                
            }
        }
    }
    func fetchFavouritePokemons(){
        let favourites = DDBBManager.shared.get(Favourites.self)
        self.presenter?.didFetchFavourites(favourites: favourites)
    }
    func fetchPokemonType(type: String) {
        PokemonManager.shared.fetchPokemonTypes(pokemonType: type, { pokemonFilterListData, error in
            if let error = error {
                self.presenter?.didFailWith(error: error)
            }else{
                self.presenter?.didFetchType(pokemons: pokemonFilterListData!)
            }
            
        })
    }
}

