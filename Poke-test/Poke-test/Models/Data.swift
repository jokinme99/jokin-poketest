
import UIKit
import RealmSwift

//MARK: - PokemonList
class Results: Object, Codable{
    @objc dynamic var name: String?
}
class PokemonListData:Object, Codable{
    let results = List<Results>()
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Map your JSON Array response
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
}
class Sprites: Codable{
    let front_default:String?
}
class Type:  Codable{
    let name: String
}
class Types: Codable{
    let type: Type
}

//MARK: - Favourites
//    Favoritos - UserDefaults(Not Working)
//    public func addFavourite(_ pokemon: Results){
//        results.append(pokemon)
//        let data = try! JSONEncoder().encode(results)
//        UserDefaults.standard.set(data, forKey: "favouritePokemons")
//    }
//    public func loadFavourites(){
//        let data = UserDefaults.standard.data(forKey: "favouritePokemons")
//        results = try! JSONDecoder().decode([Results].self, from: data!)
//        for pokemon in results{
//            print("\(pokemon.name ?? "no favourites yet!")")
//        }
//    }
//    public func removeFavourite(_ pokemon: Results){
//        if results.contains(pokemon){
//            if let index = results.firstIndex(of: pokemon) {
//                results.remove(at: index)
//            }
//            let data = try! JSONEncoder().encode(results)
//            UserDefaults.standard.set(data, forKey: "favouritePokemons")
//        }
//    }
//    public func containsFavourite(_ pokemon: Results) -> Bool{
//        let data = UserDefaults.standard.data(forKey: "favouritePokemons")
//        results = try! JSONDecoder().decode([Results].self, from: data!)
//        if results.contains(pokemon){
//            return true
//        }else{
//            return false
//        }
//
//    }

