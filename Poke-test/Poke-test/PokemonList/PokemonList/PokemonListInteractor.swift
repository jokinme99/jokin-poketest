//
//  PokemonListInteractor.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import RealmSwift

class PokemonListInteractor : PokemonListInteractorDelegate{
    
    var presenter: PokemonListInteractorOutputDelegate?
    
    func fetchPokemonList() {
        PokemonManager.shared.fetchList { pokemonList, error in
            if let error = error {
                self.presenter?.didFailWith(error: error)
            } else {
                self.presenter?.didFetchPokemonList(pokemon: pokemonList!)
            }
        }
    }
    //DDBBManager.shared.get(Results.self) = DDBBManager.shared.loadFavourites()
    func fetchFavouritePokemons(){//It does work!
        let favourites = DDBBManager.shared.get(Results.self)
        self.presenter?.didFetchFavourites(favourites: favourites)
    }
    
    func fetchPokemonDetails(pokemon: Results) {
        PokemonManager.shared.fetchPokemon(pokemonSelectedName: pokemon.name!, { pokemonData, error in
            if let error = error{
                self.presenter?.didFailWith(error: error)
            }else{
                self.presenter?.didFetchPokemonDetails(pokemon: pokemonData!)
            }

        })
    }
    
}

