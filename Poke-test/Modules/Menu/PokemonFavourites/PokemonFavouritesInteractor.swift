//
//  PokemonFavouritesInteractor.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/11/21.
//
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PokemonFavouritesInteractor {
    var presenter: PokemonFavouritesInteractorOutputDelegate?
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
}

extension PokemonFavouritesInteractor: PokemonFavouritesInteractorDelegate {

    func fetchFavouritePokemons() {
        if user != nil {
            guard let user = user else { return }
            self.ref.child("users").child("\(user.uid)").observe(.value, with: {snapshot in
                if snapshot.exists() {
                    let favouritesList = snapshot.value as? [String: Any]
                    var favourites: [Favourites] = []
                    guard let favouritesList = favouritesList else {return}
                    for fav in favouritesList {
                        favourites.append(Favourites(name: fav.key))
                    }
                    self.presenter?.didFetchFavourites(favourites: favourites)
                } else {
                    let favourites: [Favourites] = []
                    self.presenter?.didFetchFavourites(favourites: favourites)
                }
            })
        } else {
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites: favourites)
        }
    }

    func fetchPokemonType(type: String) {
        if Reachability.isConnectedToNetwork() {
            PokemonManager.shared.fetchPokemonTypes(pokemonType: type, { pokemonFilterListData, error in
                if let error = error {
                    self.presenter?.didFailWith(error: error)
                } else {
                    guard let pokemonFilterListData = pokemonFilterListData else {return}
                    self.presenter?.didFetchType(pokemons: pokemonFilterListData)
                }
            })
        } else {
            let pokemons = DDBBManager.shared.get(PokemonFilterListData.self)
            for pokemon in pokemons where pokemon.name == type {
                self.presenter?.didFetchType(pokemons: pokemon)
            }
        }
    }

    func deleteFavourite(pokemon: Results) {
        if user != nil {
            guard let user = user else {return}
            guard let name = pokemon.name else {return}
            self.ref.child("users").child("\(user.uid)").child(name.capitalized).removeValue()
            self.presenter?.didDeleteFavourite(pokemon: pokemon)
        } else {
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites: favourites)
        }
    }
}
