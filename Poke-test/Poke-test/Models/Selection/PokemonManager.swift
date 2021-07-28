//
//  PokemonManager.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

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
        AF.request(urlString, method: .get, encoding: URLEncoding.queryString, headers: nil)
            .validate()
            .responseJSON { response in
                
                switch (response.result) {
                
                case .success( _):
                        if response.error != nil{
                            self.delegate?.didFailWithError(error: response.error!)
                            return
                        }
                        if let safeData = response.data{
                            if let pokemon = parseJSONPokemon(safeData){
                                self.delegate?.didUpdatePokemon(self, pokemon:pokemon)
                            }
                        }
                    
                    
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
}
