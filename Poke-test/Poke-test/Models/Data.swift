
import UIKit
import RealmSwift

//MARK: - Pokemons
class Results: Object, Codable{
    @objc dynamic var name: String?
    override static func primaryKey() -> String? {
        return "name"
    }
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
class PokemonListData:Object, Codable{
    var results = List<Results>()
    public required convenience init(from decoder: Decoder) throws { //Needed to set the array in realm Array[] -> List<>
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let favouritePokemonsList = try container.decodeIfPresent([Results].self, forKey: .results) ?? [Results()]
        results.append(objectsIn: favouritePokemonsList)
    }
}
class Favourites: Object, Codable{
    @objc dynamic var name: String?
    override static func primaryKey() -> String? {
        return "name"
    }
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}




//MARK: - Pokemons' details
/*
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
*/


 
 //MARK: - Pokemons' details
 class PokemonData: Object, Codable{
     @objc dynamic var name: String?
     @objc var sprites: Sprites?
     var types = List<Types>()
     @objc dynamic var id: Int = 0
     @objc dynamic var height: Int = 0
     @objc dynamic var weight: Int = 0
     var stats = List<Stats>()
     var abilities = List<Abilities>()
     public required convenience init(from decoder: Decoder, name:String, sprites: Sprites, types: List<Types>, id: Int, height: Int, weight: Int, stats: List<Stats>, abilities: List<Abilities>) throws {
         self.init()
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.name = name
         self.sprites = sprites
         let typeInTypes = try container.decodeIfPresent([Types].self, forKey: .types) ?? [Types()]
         types.append(objectsIn: typeInTypes)
         self.types = types
         self.id = id
         self.height = height
         self.weight = weight
         let stat = try container.decodeIfPresent([Stats].self, forKey: .stats) ?? [Stats()]
         stats.append(objectsIn: stat)
         self.stats = stats
         let abilityInAbilities = try container.decodeIfPresent([Abilities].self, forKey: .abilities) ?? [Abilities()]
         abilities.append(objectsIn: abilityInAbilities)
         self.abilities = abilities
     }
//     convenience init( name: String, sprites: Sprites, id: Int, height: Int, weight: Int) {
//         self.init()
//         self.name = name
//         self.sprites = sprites
//         self.id = id
//         self.height = height
//         self.weight = weight
//     }
     override class func primaryKey() -> String? {
         return "name"
     }
 }
 class Sprites: Object, Codable{
     @objc dynamic var front_default:String
     override static func primaryKey() -> String? {//Foto es unica
         return "front_default"
     }
     
 }
class Types: Object, Codable{
    @objc var type: Type?
}
 class Type: Object, Codable{
     @objc dynamic var name: String? //el tipo no es unico
//     override class func primaryKey() -> String? {
//         return "name"
//     }
 }

 class Stats: Object, Codable{
     @objc dynamic var base_stat: Int = 0 //las estadisticas no son unicas
//     override class func primaryKey() -> String? {
//         return "base_stat"
//     }
     
 }
 class Abilities: Object, Codable{
     @objc var ability: Ability?
 }
 class Ability: Object, Codable{
     @objc dynamic var name: String? //las habilidades no son unicas
//     override class func primaryKey() -> String? {
//         return "name"
//     }

 }
//MARK: - Pokemons' types
class PokemonFilterListData: Object, Codable{//Do the DDBBManager in DataManager
    let pokemon = List<Pokemons>()
    public required convenience init(from decoder: Decoder) throws { //Needed to set the array in realm Array[] -> List<>
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let pokemonTypes = try container.decodeIfPresent([Pokemons].self, forKey: .pokemon) ?? [Pokemons()]
        pokemon.append(objectsIn: pokemonTypes)
    }
}
class Pokemons: Object, Codable{
    @objc var pokemon: Pokemon?
}
class Pokemon: Object, Codable{
    @objc dynamic var name: String?
//    override static func primaryKey() -> String?{//Un pokemon puede estar en dos tipos, por lo que no es unico
//        return "name"
//    }
//    convenience init(name: String) {
//        self.init()
//        self.name = name
//    }

}

