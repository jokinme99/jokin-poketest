//
//  PokemonData.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import UIKit
import Alamofire


struct PokemonData:Codable{
    let name: String
    let sprites: Sprites
}

struct Sprites: Codable{
    let front_default:String
}

