
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
class Favourites{
    var name: String?
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
 //MARK: - Pokemons' details
 class PokemonData: Object, Codable {
     @objc dynamic var name: String?
     @objc dynamic var sprites: Sprites?
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

     override class func primaryKey() -> String? {
         return "name"
     }
 }
 class Sprites: EmbeddedObject, Codable{ //Not working
     @objc dynamic var front_default: String
     
     
 }
class Types: EmbeddedObject, Codable{
    @objc dynamic var type: Type?

}
 class Type: EmbeddedObject, Codable{ //Not working
     @objc dynamic var name: String? //el tipo no es unico
 }

 class Stats: EmbeddedObject, Codable{
     @objc dynamic var base_stat: Int = 0 //las estadisticas no son unicas
     convenience init(base_stat: Int) {
         self.init()
         self.base_stat = base_stat
     }
 }
 class Abilities: EmbeddedObject, Codable{
     @objc dynamic var ability: Ability?
 }
 class Ability: EmbeddedObject, Codable{//Not working
     @objc dynamic var name: String? //las habilidades no son unicas

 }
//MARK: - Pokemons' types
class PokemonFilterListData: Object, Codable{//Do the DDBBManager in DataManager
    @objc dynamic var name: String?
    var pokemon = List<Pokemons>()
    public required convenience init(from decoder: Decoder, name: String) throws { //Needed to set the array in realm Array[] -> List<>
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = name
        let pokemonTypes = try container.decodeIfPresent([Pokemons].self, forKey: .pokemon) ?? [Pokemons()]
        pokemon.append(objectsIn: pokemonTypes)
    }
    override class func primaryKey() -> String? {
        return "name"
    }
}
class Pokemons: Object, Codable{
    @objc dynamic var pokemon: Pokemon?
}
class Pokemon: EmbeddedObject, Codable{ //Not working
    @objc dynamic var name: String?

}

//MARK: - DictionaryPokemon
class PokemonDictionary{
    var pokemonInDict: Results?
    var pokemonId: Int?
    init(pokemonInDict: Results, pokemonId: Int){
        self.pokemonInDict = pokemonInDict
        self.pokemonId = pokemonId
    }
}
