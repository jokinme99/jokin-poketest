//
//  Data.swift
//  Poke-test
//
//  Created by Jokin Egia on 29/7/21.
//
import UIKit
import RealmSwift

class Results: Object, Codable {
    @objc dynamic var name: String?
    override static func primaryKey() -> String? {
        return "name"
    }
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
class PokemonListData: Object, Codable {
    var results = List<Results>()
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let favouritePokemonsList = try container.decodeIfPresent(
            [Results].self, forKey: .results) ?? [Results()]
        results.append(objectsIn: favouritePokemonsList)
    }
    convenience init(results: List<Results>) {
        self.init()
        self.results = results
    }
}
class Favourites {
    var name: String?
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

 class PokemonData: Object, Codable {
     @objc dynamic var name: String?
     @objc dynamic var sprites: Sprites?
     var types = List<Types>()
     @objc dynamic var id: Int = 0
     @objc dynamic var height: Int = 0
     @objc dynamic var weight: Int = 0
     var stats = List<Stats>()
     var abilities = List<Abilities>()
     public required convenience init(from decoder: Decoder, name: String, sprites: Sprites,
                                      types: List<Types>, id: Int, height: Int, weight: Int,
                                      stats: List<Stats>, abilities: List<Abilities>) throws {
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
     convenience init(name: String, sprites: Sprites, types: List<Types>,
                      id: Int, height: Int, weight: Int, stats: List<Stats>, abilities: List<Abilities>) {
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

 class Sprites: EmbeddedObject, Codable {
     @objc dynamic var frontDefault: String?
     enum CodingKeys: String, CodingKey {
         case frontDefault = "front_default"
     }
     convenience init(frontDefault: String) {
         self.init()
         self.frontDefault = frontDefault
     }

 }
 class Types: EmbeddedObject, Codable {
    @objc dynamic var type: Type?
     convenience init(type: Type) {
         self.init()
         self.type = type
     }

}
 class Type: EmbeddedObject, Codable {
     @objc dynamic var name: String?
     convenience init(name: String) {
         self.init()
         self.name = name
     }
 }
 class Stats: EmbeddedObject, Codable {
     @objc dynamic var baseStat: Int = 0
     enum CodingKeys: String, CodingKey {
         case baseStat = "base_stat"
     }
     convenience init(baseStat: Int) {
         self.init()
         self.baseStat = baseStat
     }
 }
 class Abilities: EmbeddedObject, Codable {
     @objc dynamic var ability: Ability?
     convenience init(ability: Ability) {
         self.init()
         self.ability = ability
     }
 }

 class Ability: EmbeddedObject, Codable {
     @objc dynamic var name: String?
     convenience init(name: String) {
         self.init()
         self.name = name
     }

 }

class PokemonFilterListData: Object, Codable {
    @objc dynamic var name: String?
    var pokemon = List<Pokemons>()
    public required convenience init(
        from decoder: Decoder, name: String) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = name
        let pokemonTypes = try container.decodeIfPresent([Pokemons].self, forKey: .pokemon) ?? [Pokemons()]
        pokemon.append(objectsIn: pokemonTypes)
    }
    override class func primaryKey() -> String? {
        return "name"
    }
    convenience init(name: String, pokemon: List<Pokemons>) {
        self.init()
        self.name = name
        self.pokemon = pokemon
    }
}
class Pokemons: Object, Codable {
    @objc dynamic var pokemon: Pokemon?
    convenience init(pokemon: Pokemon) {
        self.init()
        self.pokemon = pokemon
    }
}
class Pokemon: EmbeddedObject, Codable {
    @objc dynamic var name: String?
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

class PokemonDictionary {
    var pokemonInDict: Results?
    var pokemonId: Int?
    init(pokemonInDict: Results, pokemonId: Int) {
        self.pokemonInDict = pokemonInDict
        self.pokemonId = pokemonId
    }
}
