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
struct Results: Codable{//results[0].name = Pikachu
    var name: String?
}
//MARK: - PokemonListData methods
struct PokemonListData:Codable {//results[]
    var results: [Results] = []
}
