import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase

//MARK: - PokemonListInteractor
class PokemonListInteractor{
    var presenter: PokemonListInteractorOutputDelegate?
    var view: PokemonListViewDelegate?
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
}


//MARK: - PokemonListInteractorDelegate
extension PokemonListInteractor: PokemonListInteractorDelegate{
    
    
    //MARK: - fetchPokemonList
    func fetchPokemonList() {
        if Reachability.isConnectedToNetwork(){
            PokemonManager.shared.fetchList { pokemonList, error in
                if let error = error {
                    self.presenter?.didFailWith(error: error)
                } else {
                    guard let pokemonList = pokemonList else {return}
                    self.presenter?.didFetchPokemonList(pokemon: pokemonList)
                    
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
    
    
    //MARK: - fetchPokemonType
    func fetchPokemonType(type: String) {
        if Reachability.isConnectedToNetwork(){
            PokemonManager.shared.fetchPokemonTypes(pokemonType: type, { pokemonFilterListData, error in
                if let error = error {
                    self.presenter?.didFailWith(error: error)
                }else{
                    guard let pokemonFilterListData = pokemonFilterListData else {return}
                    self.presenter?.didFetchType(pokemons: pokemonFilterListData)
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
    
    
    //MARK: - fetchFavourites
    func fetchFavourites() {
        if user != nil{
            guard let user = user else{return}
            self.ref.child("users").child("\(user.uid)").observe(.value, with: {snapshot in
                if snapshot.exists(){
                    var favourites: [Favourites] = []
                    if snapshot.childrenCount > 0{
                        let favouritesList = snapshot.value as? [String:Any]
                        for fav in favouritesList ?? [:]{
                            favourites.append(Favourites(name: fav.key))
                        }
                        self.presenter?.didFetchFavourites(favourites: favourites)
                    }
                }else{
                    let favourites: [Favourites] = []
                    self.presenter?.didFetchFavourites(favourites: favourites)
                }
            })
        }else{
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites: favourites)
        }
        
    }
    
    
    //MARK: - addFavourite
    func addFavourite(pokemon: Results) {
        if user != nil{ //Si estÃ¡ logeado
            guard let user = user else {return}
            let allData = DDBBManager.shared.get(PokemonData.self)
            for pok in allData{
                if pok.name == pokemon.name{
                    guard let name = pok.name else{return}
                    //users.uid[0].name = "Bulbasaur" LO QUE QUIERO
                    //users.uid.Bulbasaur.name = "Bulbasaur" LO QUE HAY
                    self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").setValue(["name" : "\(name)", "id": pok.id, "url": "https://pokeapi.co/api/v2/pokemon/\(name)", "height": pok.height, "weight": pok.weight])
                    self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("stats").setValue(["hp": pok.stats[0].base_stat, "attack": pok.stats[1].base_stat, "defense":pok.stats[2].base_stat, "specialAttack": pok.stats[3].base_stat, "specialDefense": pok.stats[4].base_stat, "speed": pok.stats[5].base_stat])
                    if pok.types.count > 1{
                        self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("types").setValue(["type_1": (pok.types[0].type?.name ?? "default"), "type_2": (pok.types[1].type?.name ?? "default")])
                        if pok.abilities.count > 1{
                            self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("abilities").setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default"), "ability_2": (pok.abilities[1].ability?.name ?? "default")])
                        }
                        else{
                            self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("abilities").setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default")])
                        }
                    }
                    else{
                        self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("types").setValue(["type_1": (pok.types[0].type?.name ?? "default")])
                        if pok.abilities.count > 1{
                            self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("abilities").setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default"), "ability_2": (pok.abilities[1].ability?.name ?? "default")])
                        }else{
                            self.ref.child("users").child("\(user.uid)").child("\(name.capitalized)").child("abilities").setValue(["ability_1": (pok.abilities[0].ability?.name ?? "default")])
                        }
                    }
                    
                }
            }
            
        }else{
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites: favourites)
        }
        
        
    }
    func setInitialValues(){
        
    }
}
