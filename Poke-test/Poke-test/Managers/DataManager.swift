
import Foundation
import Alamofire
protocol PokemonListManagerDelegate { //Protocol needed to fetch the pokemon list
    func didUpdatePokemonList(_ pokemonManager: PokemonManager, pokemon: PokemonListData)
    func didFailWithError(error:Error)
}
protocol PokemonDetailsManagerDelegate { //Protocol needed to fetch the pokemon details list
    func didUpdatePokemonDetails(_ pokemonManager: PokemonManager, pokemon: PokemonData)
    func didFailWithError(error: Error)
}

struct PokemonManager{
    static var shared = PokemonManager() //Singleton
    
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
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
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
}

