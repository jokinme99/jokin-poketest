import RealmSwift

class PokemonListInteractor : PokemonListInteractorDelegate{
    var presenter: PokemonListInteractorOutputDelegate?
    var view: PokemonListViewDelegate?
    
    //MARK: - Methods that do the functionality
    func fetchPokemonList() {
        if Reachability.isConnectedToNetwork(){
            PokemonManager.shared.fetchList { pokemonList, error in
                if let error = error {
                    self.presenter?.didFailWith(error: error)
                } else {
                    self.presenter?.didFetchPokemonList(pokemon: pokemonList!)
                    
                }
            }
        }else{
            let pokemons = DDBBManager.shared.get(Results.self)
            let pokemonList = PokemonListData()
            for pokemon in pokemons {
                pokemonList.results.append(pokemon)
            }
            self.presenter?.didFetchPokemonList(pokemon: pokemonList)
        }
       
    }
    func fetchFavouritePokemons(){
        let favourites = DDBBManager.shared.get(Favourites.self)
        self.presenter?.didFetchFavourites(favourites: favourites)
    }
    func fetchPokemonType(type: String) {
        if Reachability.isConnectedToNetwork(){
            PokemonManager.shared.fetchPokemonTypes(pokemonType: type, { pokemonFilterListData, error in
                if let error = error {
                    self.presenter?.didFailWith(error: error)
                }else{
                    self.presenter?.didFetchType(pokemons: pokemonFilterListData!)
                }
                
            })
        }else{ 
            let pokemons = DDBBManager.shared.get(PokemonFilterListData.self)
            for pokemon in pokemons{
                if pokemon.name == type{
                    self.presenter?.didFetchType(pokemons: pokemon)
                }
            }
        }
       
    }
}

