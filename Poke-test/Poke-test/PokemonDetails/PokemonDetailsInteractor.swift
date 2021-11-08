
class PokemonDetailsInteractor : PokemonDetailsInteractorDelegate {
    
    var presenter: PokemonDetailsInteractorOutputDelegate?
    var dataBaseDelegate: DDBBManagerDelegate?
    var tableView: PokemonListViewDelegate?
    //MARK: - Methods that do the functionality
    func fetchPokemon(pokemon: Results) {
        if Reachability.isConnectedToNetwork(){
            PokemonManager.shared.fetchPokemon(pokemonSelectedName: pokemon.name!, { pokemonData, error in
                if let error = error{
                    self.presenter?.didFailWithError(error: error)
                }else{
                    self.presenter?.didFetchPokemon(pokemon: pokemonData!)
                }

            })
        }else{
            let pokemons = DDBBManager.shared.get(PokemonData.self)
            for pok in pokemons {
                if pok.name == pokemon.name{
                    self.presenter?.didFetchPokemon(pokemon: pok)
                }
            }
        }
       
    }
    func fetchFavouritePokemons() {//Pass from results to favs here!
        presenter?.didFetchFavourites(DDBBManager.shared.get(Favourites.self))
    }
    func addFavourite(pokemon: Results) {
        let fav = Favourites(name: pokemon.name!)
        let isSaved = isSavedFavourite(fav)
        if !isSaved.isSaved{
            let saved = Favourites()
            saved.name = fav.name
            DDBBManager.shared.save(saved){ (error) in
                self.dataBaseDelegate?.didSaveFavouriteWithError(error: error)
            }
            //presenter?.didAddFavourite(pokemon: saved) Probar 26 octubre
        }
    }
    func deleteFavourite(pokemon: Results) {
        let fav = Favourites(name: pokemon.name!)
        let isSaved = isSavedFavourite(fav)
        if isSaved.isSaved{
            if let saved = isSaved.saved{
                DDBBManager.shared.delete(saved){ (error) in
                    self.dataBaseDelegate?.didDeleteFavouriteWithError(error: error)
                }
            }
        }
    }
    func isSaved(favourite: Favourites){
        let saved = isSavedFavourite(favourite)
        dataBaseDelegate?.didIsSaved(saved: saved.isSaved)
    }
    private func isSavedFavourite(_ favourite: Favourites)-> (isSaved: Bool, saved: Favourites?){
        let filter = "name == '\(favourite.name!)'"
        let saved = DDBBManager.shared.get(Favourites.self, filter: filter)
        return (saved.count > 0, saved.first)
    }
}
//MARK: - DDBBManagerDelegate methods
extension PokemonDetailsInteractor: DDBBManagerDelegate{
    func didSaveFavouriteWithError(error: Error?) {
        presenter?.didAddFavouriteWithError(error: error)
    }
    func didIsSaved(saved: Bool) {
        presenter?.didIsSaved(saved: saved)
    }
    func didDeleteFavouriteWithError(error: Error?) {
        presenter?.didDeleteFavouriteWithError(error: error)
    }
}
