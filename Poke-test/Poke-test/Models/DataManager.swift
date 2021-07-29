

import Foundation
import Alamofire

protocol PokemonListManagerDelegate {
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData)
    func didSelectPokemonType(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData)
    func didFailWithError(error:Error)
}

struct PokemonListManager {
    let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118"
    let pokemonTypeURL = "https://pokeapi.co/api/v2/type"
    var delegate: PokemonListManagerDelegate?
    
    func fetchPokemonList(){
        performRequestList(with: pokemonListURL)
    }
    func fetchPokemonType(){
        performRequestType(with: pokemonTypeURL)
    }
    
    func performRequestList(with urlString:String){
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
    func performRequestType(with urlString:String){
        AF.request(urlString,
                   method: .get,
                   encoding: URLEncoding.queryString,
                   headers: nil)
            .validate()
            .responseDecodable { (response: DataResponse<PokemonListData, AFError>) in
                switch response.result {
                case .success(let data):
                    self.delegate?.didSelectPokemonType(self, pokemon: data)
                case .failure(let error):
                    self.delegate?.didFailWithError(error: error)
                }
            }
    }
}
protocol  PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData)
    func didFailWithError(error:Error)
}

struct PokemonManager{
    
    let pokemonDetailsURL = "https://pokeapi.co/api/v2/pokemon/"
    
    var delegate: PokemonManagerDelegate?
    func didUpdatePokemonType(){
        
    }
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



