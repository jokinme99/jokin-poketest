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
    func addFavourite(pokemon: Results) {
        let fav = Favourites(name: pokemon.name!)
        let isSaved = isSavedFavourite(fav)
        if !isSaved.isSaved{
            let saved = Favourites()
            saved.name = fav.name
            DDBBManager.shared.save(saved){ (error) in
                self.presenter?.didAddFavouriteWithError(error: error)
            }
        }
    }
    func isSaved(favourite: Favourites){
        let saved = isSavedFavourite(favourite)
        presenter?.didIsSaved(saved: saved.isSaved)
    }
    private func isSavedFavourite(_ favourite: Favourites)-> (isSaved: Bool, saved: Favourites?){
        let filter = "name == '\(favourite.name!)'"
        let saved = DDBBManager.shared.get(Favourites.self, filter: filter)
        return (saved.count > 0, saved.first)
    }
    func fetchFavourites() {
        let favourites = DDBBManager.shared.get(Favourites.self)
        self.presenter?.didFetchFavourites(favourites: favourites)
    }
}

