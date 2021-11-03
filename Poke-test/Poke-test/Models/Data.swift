
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
    let results = List<Results>()
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
/*
 
//NOT WORKING WITH REALM & PokemonDetailsViewController-> things must be changed lines 159 & 172
class PokemonData: Object, Codable{
    @objc dynamic var name: String?
    dynamic var sprites: Sprites? //LLama a otra clase que ese objeto(el de la clase) es @objc
    var types = List<Types>()
    @objc dynamic var id: Int = 0 //? not existing in objc
    @objc dynamic var height: Int = 0
    @objc dynamic var weight: Int = 0
    var stats = List<Stats>()
    var abilities = List<Abilities>()
    override class func primaryKey() -> String? {
        return "name"
    }
    public required convenience init(from decoder: Decoder) throws { //Needed to set the array in realm Array[] -> List<>
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decodeIfPresent([Types].self, forKey: .types) ?? [Types()]
        types.append(objectsIn: type)
        let stat = try container.decodeIfPresent([Stats].self, forKey: .stats) ?? [Stats()]
        stats.append(objectsIn: stat)
        let ability = try container.decodeIfPresent([Abilities].self, forKey: .abilities) ?? [Abilities()]
        abilities.append(objectsIn: ability)
        
    }
    convenience init(name: String, sprites: Sprites, types: List<Types>, id: Int, height: Int, weigth: Int, stats: List<Stats>, abilities: List<Abilities>) {
        self.init()
        self.name = name
        self.sprites = sprites
        self.types = types
        self.id = id
        self.height = height
        self.weight = weight
        self.stats = stats
        self.abilities = abilities
    }
}
class Sprites: Object, Codable{
    @objc dynamic var front_default:String?
    override class func primaryKey() -> String? {
        return "front_default"
    }
    convenience init(front_default:String) {
        self.init()
        self.front_default = front_default
    }
    
}
class Type:  Object, Codable{
    @objc dynamic var name: String //types[0]. type.name
    override class func primaryKey() -> String?{
        return "name"
    }
    convenience init(name: String){
        self.init()
        self.name = name
    }
}
class Types: Object, Codable{
    var type: Type
}
class Stats: Object, Codable{
    @objc dynamic var base_stat: Int //Valor de la estadistica
    override class func primaryKey() -> String? {
        return "base_stat"
    }
    convenience init(base_stat: Int) {
        self.init()
        self.base_stat = base_stat
    }
}
class Abilities: Object, Codable{
    var ability: Ability
}
class Ability: Object, Codable{
    @objc dynamic var name: String //abilities[0].ability.name
    override class func primaryKey() -> String? {
        return "name"
    }
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
*/
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
    override static func primaryKey() -> String?{
        return "name"
    }
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

