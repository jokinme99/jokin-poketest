//
//  PokemonDetailsInteractor.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PokemonDetailsInteractor {
    var presenter: PokemonDetailsInteractorOutputDelegate?
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
}

extension PokemonDetailsInteractor: PokemonDetailsInteractorDelegate {

    func fetchPokemon(pokemon: Results) {
        if Reachability.isConnectedToNetwork() {
            guard let name = pokemon.name else {return}
            PokemonManager.shared.fetchPokemon(pokemonSelectedName: name, { pokemonData, error in
                if let error = error {
                    self.presenter?.didFailWithError(error: error)
                } else {
                    guard let pokemonData = pokemonData else {return}
                    self.presenter?.didFetchPokemon(pokemon: pokemonData)
                }
            })
        } else {
            let pokemons = DDBBManager.shared.get(PokemonData.self)
            for pok in pokemons where pok.name == pokemon.name {
                self.presenter?.didFetchPokemon(pokemon: pok)
            }
        }
    }

    func fetchFavouritePokemons() {
        if user != nil {
            guard let user = user else {return}
            self.ref.child("users").child("\(user.uid)").observe(.value, with: { snapshot in
                if snapshot.exists() {
                    let favouritesList = snapshot.value as? [String: Any]
                    var favourites: [Favourites] = []
                    guard let favouritesList = favouritesList else {return}
                    for fav in favouritesList {
                        favourites.append(Favourites(name: fav.key))
                    }
                    self.presenter?.didFetchFavourites(favourites)
                } else {
                    let favourites: [Favourites] = []
                    self.presenter?.didFetchFavourites(favourites)
                }
            })
        } else {
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites)
        }
    }

    func addFavourite(pokemon: Results) {
        if user != nil {
            guard let user = user else {return}
            let allData = DDBBManager.shared.get(PokemonData.self)
            for pok in allData where pok.name == pokemon.name {
                guard let name = pok.name else {return}
                self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)")
                    .setValue(["name": "\(name)", "id": pok.id, "url": "https://pokeapi.co/api/v2/pokemon/\(name)",
                               "height": pok.height, "weight": pok.weight])
                self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)")
                    .child("stats").setValue(["hp": pok.stats[0].baseStat,
                                              "attack": pok.stats[1].baseStat, "defense": pok.stats[2].baseStat,
                                              "specialAttack": pok.stats[3].baseStat,
                                              "specialDefense": pok.stats[4].baseStat,
                                              "speed": pok.stats[5].baseStat])
                if pok.types.count > 1 {
                    self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("types")
                        .setValue( ["type_1": (pok.types[0].type?.name ?? "default"),
                                    "type_2": (pok.types[1].type?.name ?? "default")])
                    if pok.abilities.count > 1 {
                        self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)")
                            .child("abilities").setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default"),
                                                          "ability_2": (pok.abilities[1].ability?.name ?? "default")])
                    } else {
                        self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("abilities")
                            .setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default")])
                    }
                } else {
                    self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("types")
                        .setValue(["type_1": (pok.types[0].type?.name ?? "default")])
                    if pok.abilities.count > 1 {
                        self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("abilities")
                            .setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default"),
                                       "ability_2": (pok.abilities[1].ability?.name ?? "default")])
                    } else {
                        self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("abilities")
                            .setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default")])
                    }
                }
            }
            self.presenter?.didAddFavourite(pokemon: pokemon)
        } else {
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites)
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
            self.presenter?.didFetchFavourites(favourites)
        }
    }
}
