

import UIKit
struct Results: Codable{
    var name: String?
}
struct PokemonListData:Codable {
    var results: [Results] = []
}

struct PokemonData: Codable{
    let name: String
    let sprites: Sprites
    let types: [Types]
}
struct Sprites: Codable{
    let front_default:String?
}
struct Type: Codable{
    let name: String 
}
struct Types: Codable{
    let type: Type
}
