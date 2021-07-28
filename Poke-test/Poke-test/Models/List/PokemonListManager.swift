//
//  PokemonListManager.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import Foundation
import Alamofire

protocol PokemonListManagerDelegate {
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData)
    func didFailWithError(error:Error)
}

struct PokemonListManager {
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


