
import Alamofire
import RealmSwift

class PokemonManager{
    static var shared = PokemonManager()
    //MARK: - Fetch Pokemon List
    func fetchList( _ completion:  @escaping  (PokemonListData?, Error?) -> Void){
        let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118"
        AF.request(pokemonListURL,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: nil)
            .validate()
            .responseDecodable { (response: DataResponse<PokemonListData, AFError>) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                    self.addPokemonListData(data)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    func addPokemonListData(_ pokemons: PokemonListData){
        //if pokemon exist nothing(check with isSaved method)
        //if not save them
        let isSaved = isSavedPokemonInList(pokemons)
        if !isSaved.isSaved{//If doesn't exist
            DDBBManager.shared.save(pokemons){(error) in
                self.didSaveWithError(error: error)
            }
        }
    }
    func isSaved(pokemonList: PokemonListData){
        let saved = isSavedPokemonInList(pokemonList)
        didIsSaved(saved: saved.isSaved)
    }
    func isSavedPokemonInList(_ pokemonList: PokemonListData)-> (isSaved: Bool, saved: Results?){
        for pokemonInlist in pokemonList.results{//Run pokemonList's results
            let filter = "name == '\(pokemonInlist.name!)'" //Make the SQL sentence to compare the names of the pokemons
            let saved = DDBBManager.shared.get(Results.self, filter: filter) // Use the SQL sentence into the Database and get the list of the objects fetched with the SQL sentence
            return (saved.count > 0, saved.first)
        }
        return(false, Results())//?
    }
    
    //MARK: - Fetch Pokemon Details
    func fetchPokemon(pokemonSelectedName: String, _ completion:  @escaping  (PokemonData?, Error?) -> Void){
        let pokemonDetailsURL = "https://pokeapi.co/api/v2/pokemon/\(pokemonSelectedName)"
        AF.request(pokemonDetailsURL,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: nil)
            .validate()
            .responseDecodable { (response: DataResponse<PokemonData, AFError>) in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    //MARK: - Fetch Pokemon Types
    func fetchPokemonTypes(pokemonType: String, _ completion: @escaping(PokemonFilterListData?, Error?)-> Void){
        let pokemonFilterURL = "https://pokeapi.co/api/v2/type/\(pokemonType)"
        AF.request(pokemonFilterURL,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: nil)
            .validate()
            .responseDecodable{ (response: DataResponse<PokemonFilterListData, AFError>) in
                switch response.result{
                case .success(let data):
                    completion(data,nil)
                    //self.addPokemonTypeData(data)//Add all pokemons of all types
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
//    func addPokemonTypeData(_ pokemons: PokemonFilterListData){
//        //if pokemon exist nothing(check with isSaved method)
//        //if not save them
//        let isSaved = isSavedPokemonInList(pokemons)
//        if !isSaved.isSaved{//If doesn't exist
//            DDBBManager.shared.save(pokemons){(error) in
//                self.didSaveWithError(error: error)
//            }
//        }
//    }
//    func isSaved(pokemonList: PokemonFilterListData){
//        let saved = isSavedPokemonInList(pokemonList)
//        didIsSaved(saved: saved.isSaved)
//    }
//    func isSavedPokemonInList(_ pokemonList: PokemonFilterListData)-> (isSaved: Bool, saved: Pokemons?){
//        for pok in pokemonList.pokemon{//Run pokemonList's results
//            //let filter = "name == '\(String(describing: pok.pokemon?.name))'" //Make the SQL sentence to compare the names of the pokemons
//            let saved = DDBBManager.shared.get(Pokemons.self) // Use the SQL sentence into the Database and get the list of the objects fetched with the SQL sentence
//            return (saved.count > 0, saved.first)
//        }
//        return(false, Pokemons())//?
//    }
    
    func didIsSaved(saved: Bool) {
        print(saved)
    }
    
    func didSaveWithError(error: Error?) {
        print(error)
    }
    
    
}



