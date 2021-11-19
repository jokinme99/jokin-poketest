//
//  PokemonFavouritesInteractor.swift
//  Poke-test
//
//  Created by Jokin Egia on 12/11/21.
//

class PokemonFavouritesInteractor : PokemonFavouritesInteractorDelegate {
    var presenter: PokemonFavouritesInteractorOutputDelegate?
    var dataBaseDelegate: DDBBManagerDelegate?
    func fetchFavouritePokemons() {
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
    func deleteFavourite(pokemon: Results) {
        let fav = Favourites(name: pokemon.name!)
        let isSaved = isSavedFavourite(fav)
        if isSaved.isSaved{
            if let saved = isSaved.saved{
                DDBBManager.shared.delete(saved){ (error) in
                    self.presenter?.didDeleteFavouriteWithError(error: error)
                }
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
    
}
