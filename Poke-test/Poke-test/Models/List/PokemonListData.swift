//
//  PokemonListData.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import UIKit
struct Results: Codable{
    var name: String?
}

struct PokemonListData:Codable {
    var results: [Results] = []
}
