
import Firebase
import FirebaseAuth
import FirebaseDatabase

//MARK: - PokemonFavouritesInteractor
class PokemonFavouritesInteractor{
    var presenter: PokemonFavouritesInteractorOutputDelegate?
    let ref = Database.database().reference()
    let user = Auth.auth().currentUser
}


//MARK: - PokemonFavouritesInteractorDelegate methods
extension PokemonFavouritesInteractor: PokemonFavouritesInteractorDelegate {
    
    
    //MARK: - fetchFavouritePokemons
    func fetchFavouritePokemons() {
        if user != nil{
            guard let user = user else{return}
            self.ref.child("users").child("\(user.uid)").observe(.value, with: {snapshot in
                if snapshot.exists(){
                    let favouritesList = snapshot.value as![String:Any]
                    var favourites: [Favourites] = []
                    for fav in favouritesList{
                        favourites.append(Favourites(name: fav.key))
                    }
                    self.presenter?.didFetchFavourites(favourites: favourites)
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
    
    
    //MARK: - deleteFavourite
    func deleteFavourite(pokemon: Results) {
        if user != nil{
            guard let user = user else {return}
            guard let name = pokemon.name else{return}
            self.ref.child("users").child("\(user.uid)").child(name.capitalized).removeValue()
            self.presenter?.didDeleteFavourite(pokemon: pokemon)
        }else{
            let favourites: [Favourites] = []
            self.presenter?.didFetchFavourites(favourites: favourites)
        }
    }
}
