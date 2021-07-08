//
//  PokemonData.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import UIKit

struct PokemonData:Codable{
    let name: String // The one selected from the pokemonList
    let sprites: Sprites
}
struct Sprites: Codable{
    let front_default:String //Image
}
