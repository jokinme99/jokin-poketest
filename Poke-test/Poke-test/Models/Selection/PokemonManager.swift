
import Foundation
import Alamofire
protocol  PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData)
    func didFailWithError(error:Error)
}


struct PokemonManager{
    
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
