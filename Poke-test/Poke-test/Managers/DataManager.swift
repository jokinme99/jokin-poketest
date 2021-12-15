
import Alamofire
import RealmSwift

//MARK: - PokemonManager class
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
                    if DDBBManager.shared.get(PokemonListData.self).isEmpty{
                        self.addOfflineData(data)
                    }
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
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
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }}


//MARK: - Offline Storage methods
extension PokemonManager{
    //Only do it if everything is empty
    func addOfflineData(_ pokemons: PokemonListData){
        let isSaved = isSavedPokemonInList(pokemons)
        if !isSaved.isSaved{
            DDBBManager.shared.save(pokemons){(error) in
                self.didSaveWithError(error: error)
            }
        }
        for pokemon in pokemons.results {
            guard let name = pokemon.name else{return}
            PokemonManager.shared.fetchPokemon(pokemonSelectedName: name , { pokemonData, error in
                if let error = error{
                    print(error)
                }else{
                    guard let pokemonData = pokemonData else {return}
                    self.addPokemonData(pokemonData)
                }
            })
        }
        let pokemonTypes =  [TypeName.normal, TypeName.fight, TypeName.flying, TypeName.poison, TypeName.ground, TypeName.rock, TypeName.bug, TypeName.ghost, TypeName.steel, TypeName.fire, TypeName.water, TypeName.grass,TypeName.electric, TypeName.psychic, TypeName.ice, TypeName.dragon, TypeName.dark, TypeName.fairy, TypeName.unknown, TypeName.shadow]
        for type in pokemonTypes {
            PokemonManager.shared.fetchPokemonTypes(pokemonType: type, {pokemonFilterListData, error in
                if let error = error {
                    print(error)
                }else{
                    guard let pokemonFilterListData = pokemonFilterListData else {return}
                    self.addPokemonTypeData(pokemonFilterListData)
                }
            })
        }
        
    }
    func addPokemonData(_ pokemons: PokemonData){
        let isSaved = isSavedPokemonDataInList(pokemons)
        if !isSaved.isSaved{
            DDBBManager.shared.save(pokemons){(error) in
                self.didSaveWithError(error: error)
            }
        }
    }
    func addPokemonTypeData(_ pokemons: PokemonFilterListData){
        let isSaved = isSavedPokemonFilterData(pokemons)
        if !isSaved.isSaved{
            DDBBManager.shared.save(pokemons){(error) in
                self.didSaveWithError(error: error)
            }
        }
    }
    
    //IsSavedChecking methods
    func isSaved(pokemonList: PokemonData){
        let saved = isSavedPokemonDataInList(pokemonList)
        didIsSaved(saved: saved.isSaved)
    }
    func isSavedPokemonDataInList(_ pokemonList: PokemonData)-> (isSaved: Bool, saved: PokemonData?){
        let filter = "name == '\(pokemonList.name!)'"
        let saved = DDBBManager.shared.get(PokemonData.self, filter: filter)
        return (saved.count > 0, saved.first)
    }
    func isSaved(pokemonList: PokemonListData){
        let saved = isSavedPokemonInList(pokemonList)
        didIsSaved(saved: saved.isSaved)
    }
    func isSavedPokemonInList(_ pokemonList: PokemonListData)-> (isSaved: Bool, saved: Results?){
        for pokemonInlist in pokemonList.results{
            let filter = "name == '\(pokemonInlist.name!)'"
            let saved = DDBBManager.shared.get(Results.self, filter: filter)
            return (saved.count > 0, saved.first)
        }
        return(false, Results())
    }
    func isSaved(pokemonList: PokemonFilterListData){
        let saved = isSavedPokemonFilterData(pokemonList)
        didIsSaved(saved: saved.isSaved)
    }
    func isSavedPokemonFilterData(_ pokemonList: PokemonFilterListData)-> (isSaved: Bool, saved: PokemonFilterListData?){
        let filter = "name == '\(pokemonList.name!)'"
        let saved = DDBBManager.shared.get(PokemonFilterListData.self, filter: filter)
        return (saved.count > 0, saved.first)
    }
    func didIsSaved(saved: Bool) {
        print(saved)
    }
    func didSaveWithError(error: Error?) {
        print("error")
    }
}



