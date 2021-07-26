//
//  PokemonListManager.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import Foundation
import Alamofire
//Class for recovering the list of all the pokemons
protocol PokemonListManagerDelegate {
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData)
    func didFailWithError(error:Error)
}

struct PokemonListManager {
    let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118"
    
    var delegate: PokemonListManagerDelegate?
    
    func fetchPokemonList(){//Do not need anything to search for
        performRequest(with: pokemonListURL)
        
        
    }
    
    func performRequest(with urlString:String){
        AF.request(urlString, method: .get, encoding: URLEncoding.queryString, headers: nil).validate().responseJSON { response in
            switch (response.result) {
                case .success( _):
                    do {
                        if response.error != nil{
                            self.delegate?.didFailWithError(error: response.error!)
                            return
                        }
                        if let safeData = response.data{
                            if let pokemon = parseJSONPokemonList(safeData){
                                self.delegate?.didUpdatePokemonList(self, pokemon:pokemon)
                            }
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                case .failure(let error):
                    print("Request error: \(error.localizedDescription)")
                }
            }
    }
}


