
import Foundation
import Alamofire


struct PokemonManager{
    static var shared = PokemonManager() //Singleton
    
    func fetchList( _ completion:  @escaping  (PokemonListData?, Error?) -> Void){
#if DEBUG
        let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118" //1118
#else
        let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118" //1118
#endif
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

