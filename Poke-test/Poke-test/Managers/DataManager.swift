
import Foundation
import Alamofire
protocol PokemonListManagerDelegate { //Protocol needed to fetch the pokemon list
    func didUpdatePokemonList(_ pokemonManager: PokemonManager, pokemon: PokemonListData)
    func didFailWithError(error:Error)
}

protocol PokemonManagerDelegate { //Protocol needed to fetch the pokemon details list
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData)
    func didFailWithError(error:Error)
}

struct PokemonManager{
    static var shared = PokemonManager() //Singleton
    //MARK: - Pokemons list
    let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118"
    var listDelegate: PokemonListManagerDelegate?
    
    func fetchPokemonList(){
        performListRequest(with: pokemonListURL)
    }
    func performListRequest(with urlString:String){
        AF.request(urlString,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: nil)
            .validate()
            .responseDecodable { (response: DataResponse<PokemonListData, AFError>) in
                switch response.result {
                case .success(let data):
                    self.listDelegate?.didUpdatePokemonList(self, pokemon: data)
                case .failure(let error):
                    self.delegate?.didFailWithError(error: error)
                }
            }
    }
    //MARK: - Pokemon details
    let pokemonDetailsURL = "https://pokeapi.co/api/v2/pokemon/"
    var delegate: PokemonManagerDelegate?
    
    func fetchPokemon(namePokemon: String){
        let urlString = "\(pokemonDetailsURL)\(namePokemon)"
        performRequest(with:urlString)
    }
    func performRequest(with urlString:String){
        AF.request(urlString,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: nil)
            .validate()
            .responseDecodable { (response: DataResponse<PokemonData, AFError>) in
                switch response.result {
                case .success(let data):
                    self.delegate?.didUpdatePokemon(self, pokemon: data)
                case .failure(let error):
                    self.delegate?.didFailWithError(error: error)
                }
            }
    }
}

