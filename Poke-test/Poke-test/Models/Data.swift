
import UIKit
import RealmSwift

//MARK: - PokemonList
class Results: Object, Codable{
    @objc dynamic var name: String?
    override class func primaryKey() -> String? {
        return "name"
    }
}
class PokemonListData:Object, Codable{
    let results = List<Results>()
    public required convenience init(from decoder: Decoder) throws { //Needed to set the array in realm Array[] -> List<>
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let favouritePokemonsList = try container.decodeIfPresent([Results].self, forKey: .results) ?? [Results()]
        results.append(objectsIn: favouritePokemonsList)
        
    }
}

//MARK: - Pokemon details
class PokemonData: Codable{
    let name: String
    let sprites: Sprites
    let types: [Types]
    let id: Int
    let height: Int
    let weight: Int
    let stats: [Stats]
    let abilities: [Abilities]
}
class Sprites: Codable{
    let front_default:String?
}
class Type:  Codable{
    let name: String //types[0].type.name
}
class Types: Codable{
    let type: Type
}
class Stats: Codable{
    let base_stat: Int //Valor de la estadistica
}
class Abilities: Codable{
    let ability: Ability
}
class Ability: Codable{
    let name: String //abilities[0].ability.name
}

