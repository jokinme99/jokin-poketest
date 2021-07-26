//
//  PokemonData.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import UIKit
import Alamofire

//MARK: - PokemonData methods
struct PokemonData:Codable{
    let name: String // name
    let sprites: Sprites // Sprites.front_default
    
    enum CodingKeys: String, CodingKey{
        case name
        case sprites
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.sprites = try container.decode(Sprites.self, forKey: .sprites)
    }
}
//MARK: - Sprites methods
struct Sprites: Codable{
    let front_default:String //Image
    enum CodingKeys: String, CodingKey{
        case front_default
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.front_default = try container.decode(String.self, forKey: .front_default)
    }
}
//MARK: - Encoding methods
func parseJSONPokemon(_ pokemonData: Data)->PokemonData?{
    let myResponse = try! JSONDecoder().decode(PokemonData.self, from: pokemonData)
    return myResponse
}

