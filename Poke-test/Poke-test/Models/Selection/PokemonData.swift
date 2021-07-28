

import UIKit
import Alamofire


struct PokemonData:Codable{
    let name: String
    let sprites: Sprites
}

struct Sprites: Codable{
    let front_default:String
}

