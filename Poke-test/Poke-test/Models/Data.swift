

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
    let front_default:String? //There are a few pokemon that do not have a picture yet
}
struct Type: Codable{
    let name: String 
}
struct Types: Codable{
    let type: Type //type.name
}

//struct PokemonTypeData:Codable {
//    let pokemon: [Pokemon]//pokemon[0].pokemon.name
//    
//}
//struct Pokemon:Codable {
//    let pokemon: Name
//}
//struct Name:Codable {
//    let name: String
//}
