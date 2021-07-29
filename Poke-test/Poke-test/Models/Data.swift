

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
    let types: [Types] //types[0].type.name
}

struct Sprites: Codable{
    let front_default:String
}

struct Type: Codable{
    let name: String //name
}

struct Types: Codable{
    let type: Type //type.name
}
//struct PokemonTypeData: Codable{
//    var results: [Results] = []
//}

