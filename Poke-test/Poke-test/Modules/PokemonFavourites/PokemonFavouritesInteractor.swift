//
//  PokemonFavouritesInteractor.swift
//  Poke-test
//
//  Created by Jokin Egia on 12/11/21.
//

class PokemonFavouritesInteractor : PokemonFavouritesInteractorDelegate {
    var presenter: PokemonFavouritesInteractorOutputDelegate?
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
    
    
    
    
}
