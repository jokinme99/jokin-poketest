

import UIKit
struct Results: Codable{
    var name: String?
}

struct PokemonListData:Codable {
    var results: [Results] = []
}
