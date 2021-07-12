//
//  PokemonListManager.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import Foundation
//Class for recovering the list of all the pokemons
protocol PokemonListManagerDelegate {
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListModel)
    func didFailWithError(error:Error)
}

struct PokemonListManager {
    let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=1118"
    
    var delegate: PokemonListManagerDelegate?
    
    func fetchPokemonList(){//Do not need anything to search for
        performRequest(with: pokemonListURL)
    }
    func performRequest(with urlString:String){
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URL session
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let pokemon = self.parseJSON(safeData){
                        self.delegate?.didUpdatePokemonList(self, pokemon:pokemon)
                    }
                }
            }
            //4. Start a task
            task.resume()
        }
    }
    func parseJSON(_ pokemonData: Data)->PokemonListModel?{
            let decoder = JSONDecoder()
            do{
               let decodedData = try decoder.decode(PokemonListData.self, from: pokemonData)
                let dataFromResults = decodedData.results
                var arrayStrings = [String]()
                
                //Array of object result each result has name, url
                //Do an array of the names[result[0].name, result[1].name...result[1117].name]
                for result in dataFromResults {
                   arrayStrings.append(result.name)
                }
                let pokemon = PokemonListModel(names: arrayStrings)
                return pokemon
                
            }catch{
                self.delegate?.didFailWithError(error: error)
                return nil
            }
    
        }

}


