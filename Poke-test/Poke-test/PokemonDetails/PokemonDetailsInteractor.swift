
import RealmSwift
class PokemonDetailsInteractor : PokemonDetailsInteractorDelegate {
    
    var presenter: PokemonDetailsInteractorOutputDelegate?
    var dataBaseDelegate: DDBBManagerDelegate?
    //MARK: - Methods that do the functionality
    func fetchPokemon(pokemon: Results) {
        PokemonManager.shared.fetchPokemon(pokemonSelectedName: pokemon.name!, { pokemonData, error in
            if let error = error{
                self.presenter?.didFailWithError(error: error)
            }else{
                self.presenter?.didFetchPokemon(pokemon: pokemonData!)
            }

        })
    }

    
    func fetchFavouritePokemons() {
        presenter?.didFetchFavourites(DDBBManager.shared.get(Results.self))
    }
    
    func addFavourite(pokemon: Results) {
        let isSaved = isSavedFavourite(pokemon)
        if !isSaved.isSaved{
            let saved = Results()
            saved.name = pokemon.name
            DDBBManager.shared.save(saved){ (error) in
                self.dataBaseDelegate?.didSaveFavouriteWithError(error: error)
                
            }
        }
    }
    
    func deleteFavourite(pokemon: Results) {
        let isSaved = isSavedFavourite(pokemon)
        if isSaved.isSaved{
            if let saved = isSaved.saved{
                DDBBManager.shared.delete(saved){ (error) in
                    self.dataBaseDelegate?.didDeleteFavouriteWithError(error: error)
                }
            }
        }
    }
    
    func isSaved(favourite: Results){
        let saved = isSavedFavourite(favourite)
        dataBaseDelegate?.didIsSaved(saved: saved.isSaved)
    }
    private func isSavedFavourite(_ favourite: Results)-> (isSaved: Bool, saved: Results?){
        let filter = "name == '\(favourite.name!)'"
        let saved = DDBBManager.shared.get(Results.self, filter: filter)
        return (saved.count > 0, saved.first)
    }
   
}
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
