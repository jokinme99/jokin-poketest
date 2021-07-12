//
//  PokemonListData.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import UIKit

struct PokemonListData:Codable {
    let results: [Results]
}
struct Results:Codable{
    let name:String
}


