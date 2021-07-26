//
//  PokemonListData.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import UIKit
//API:
//"next": null,
//"previous": null,
//"results": [
//{
//"name": "bulbasaur"
//MARK: - Results methods
struct Results:Codable{//results[0].name = Pikachu
    let name:String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
//MARK: - PokemonListData methods
struct PokemonListData:Codable {//results[]
    var results: [Results]
    
    enum CodingKeys: String, CodingKey {//Array of results
        case results
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try container.decode([Results].self, forKey: .results)
    }
}
//MARK: - Encoding method
func parseJSONPokemonList(_ pokemonListData: Data)->PokemonListData?{
    var myResponse = try! JSONDecoder().decode(PokemonListData.self, from: pokemonListData)
    let dataFromResults = myResponse.results
    
    for result in dataFromResults {
        myResponse.results.append(result)
    }
    return myResponse
}

