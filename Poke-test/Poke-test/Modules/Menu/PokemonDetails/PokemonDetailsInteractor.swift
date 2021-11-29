import Firebase
import FirebaseDatabase
import FirebaseAuth

class PokemonDetailsInteractor : PokemonDetailsInteractorDelegate {
    
    var presenter: PokemonDetailsInteractorOutputDelegate?
    var dataBaseDelegate: DDBBManagerDelegate?
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
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
        if user != nil{
            guard let user = user else{return}
            self.ref.child("users").child(user.uid).child("Favourites").observe(.value, with: {snapshot in
                self.ref.child("users").child(user.uid).child("Favourites").removeAllObservers()
                if snapshot.exists(){
                    let favouritesList = snapshot.value as![String:Any]
                    var favourites: [Favourites] = []
                    for fav in favouritesList{
                        favourites.append(Favourites(name: fav.key))
                    }
                    self.presenter?.didFetchFavourites(favourites)
                    
                }else{
                    let favourites: [Favourites] = []
                    self.presenter?.didFetchFavourites(favourites)
                }
            })
        }else{
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites)
        }
    
    }
    func addFavourite(pokemon: Results) {
        if user != nil{ //Si está logeado
            guard let user = user else {return}
            let allData = DDBBManager.shared.get(PokemonData.self)
            for pok in allData{
                if pok.name == pokemon.name{
                    guard let name = pok.name else{return}
                    if pok.types.count > 1{//FAVS IF NO INTERNET CONNECTION
                        if pok.abilities.count > 1{
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).setValue(["0) Id": pok.id, "1) Types": "\(pok.types[0].type?.name ?? "default"), \(pok.types[1].type?.name ?? "default")", "2) Abilities":"\(pok.abilities[0].ability?.name ?? "default"), \(pok.abilities[1].ability?.name ?? "default")", "5) Url": "https://pokeapi.co/api/v2/pokemon/\(name)"])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("3) Height & Weight").setValue(["1) Height":pok.height, "2) Weight": pok.weight])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("4) Stats").setValue(["1) HP": pok.stats[0].base_stat, "2) ATTACK": pok.stats[1].base_stat, "3) DEFENSE":pok.stats[2].base_stat, "4) SPECIAL ATTACK": pok.stats[3].base_stat, "5) SPECIAL DEFENSE": pok.stats[4].base_stat, "6) SPEED": pok.stats[5].base_stat])
                        }else{
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).setValue(["0) Id": pok.id, "1) Types": "\(pok.types[0].type?.name ?? "default"), \(pok.types[1].type?.name ?? "default")", "2) Ability":"\(pok.abilities[0].ability?.name ?? "default")", "5) Url": "https://pokeapi.co/api/v2/pokemon/\(name)"])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("3) Height & Weight").setValue(["1) Height":pok.height, "2) Weight": pok.weight])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("4) Stats").setValue(["1) HP": pok.stats[0].base_stat, "2) ATTACK": pok.stats[1].base_stat, "3) DEFENSE":pok.stats[2].base_stat, "4) SPECIAL ATTACK": pok.stats[3].base_stat, "5) SPECIAL DEFENSE": pok.stats[4].base_stat, "6) SPEED": pok.stats[5].base_stat])
                        }
                        
                    }else{//Solo 1
                        if pok.abilities.count > 1{
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).setValue(["0) Id": pok.id, "1) Type": pok.types[0].type?.name ?? "default", "2) Abilities":"\(pok.abilities[0].ability?.name ?? "default"), \(pok.abilities[1].ability?.name ?? "default")", "5) Url": "https://pokeapi.co/api/v2/pokemon/\(name)"])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("3) Height & Weight").setValue(["1) Height":pok.height, "2) Weight": pok.weight])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("4) Stats").setValue(["1) HP": pok.stats[0].base_stat, "2) ATTACK": pok.stats[1].base_stat, "3) DEFENSE":pok.stats[2].base_stat, "4) SPECIAL ATTACK": pok.stats[3].base_stat, "5) SPECIAL DEFENSE": pok.stats[4].base_stat, "6) SPEED": pok.stats[5].base_stat])
                        }else{
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).setValue(["0) Id": pok.id, "1) Types": "\(pok.types[0].type?.name ?? "default")", "2) Ability":"\(pok.abilities[0].ability?.name ?? "default")", "5) Url": "https://pokeapi.co/api/v2/pokemon/\(name)"])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("3) Height & Weight").setValue(["1) Height":pok.height, "2) Weight": pok.weight])
                            self.ref.child("users").child(user.uid).child("Favourites").child(name).child("4) Stats").setValue(["1) HP": pok.stats[0].base_stat, "2) ATTACK": pok.stats[1].base_stat, "3) DEFENSE":pok.stats[2].base_stat, "4) SPECIAL ATTACK": pok.stats[3].base_stat, "5) SPECIAL DEFENSE": pok.stats[4].base_stat, "6) SPEED": pok.stats[5].base_stat])
                        }
                    }
                    
                }
            }
            self.presenter?.didAddFavourite(pokemon: pokemon)
            
        }else{
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites)
        }
    }
    func deleteFavourite(pokemon: Results) {
        if user != nil{
            guard let user = user else {return}
            guard let name = pokemon.name else{return}
            self.ref.child("users").child(user.uid).child("Favourites").child(name).removeValue()
            self.presenter?.didDeleteFavourite(pokemon: pokemon)
        }else{
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites)
        }
    }
}
