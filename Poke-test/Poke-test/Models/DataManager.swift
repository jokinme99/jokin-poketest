
import Foundation
import Alamofire

//MARK: - PokemonListManager
protocol PokemonListManagerDelegate { //Protocols needed to fetch the pokemon list
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData)
    func didFailWithError(error:Error)
}
struct PokemonListManager { //Struct that manages the fetching of the pokemon list
    let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118"
    var delegate: PokemonListManagerDelegate?
    
    func fetchPokemonList(){
        performRequest(with: pokemonListURL)
    }
    
    func performRequest(with urlString:String){
        AF.request(urlString,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: nil)
            .validate()
            .responseDecodable { (response: DataResponse<PokemonListData, AFError>) in
                switch response.result {
                case .success(let data):
                    self.delegate?.didUpdatePokemonList(self, pokemon: data)
                case .failure(let error):
                    self.delegate?.didFailWithError(error: error)
                    
                }
            }
    }
}

//MARK: - PokemonManager
protocol  PokemonManagerDelegate { //Protocols needed to fetch the pokemon details list
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData)
    func didFailWithError(error:Error)
}
struct PokemonManager{ //Struct that manages the fetching of the details of a specified pokemon
    
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
