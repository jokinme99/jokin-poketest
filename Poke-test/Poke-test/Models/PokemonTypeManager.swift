//
//import Foundation
//import Alamofire
//protocol  PokemonTypeManagerDelegate {
//    func selectNormalPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectFightPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectFlyingPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectPoisonPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectGroundPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectRockPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectBugPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectGhostPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectSteelPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectFirePokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectWaterPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectGrassPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectElectricPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectPsychicPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectIcePokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectDragonPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectDarkPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectFairyPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectUnknownPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    func selectShadowPokemon(_ pokemonManager: PokemonTypeManager, pokemon: PokemonTypeData)
//    
//    func didFailWithError(error:Error)
//}
//
//struct PokemonTypeManager{
//    
//    let pokemonDetailsURL = "https://pokeapi.co/api/v2/type/"
//    
//    var delegate: PokemonTypeManagerDelegate?
//    //One fetch function per Pokemon type this type compare to the first type[0].type.name
//    func fetchPokemonNormalType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.normal)"
//        performRequestNormal(with:urlString)
//    }
//    func fetchPokemonFightType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.fight)"
//        performRequestFight(with:urlString)
//    }
//    func fetchPokemonFlyingType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.flying)"
//        performRequestFlying(with:urlString)
//    }
//    func fetchPokemonPoisonType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.poison)"
//        performRequestPoison(with:urlString)
//    }
//    func fetchPokemonGroundType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.ground)"
//        performRequestGround(with:urlString)
//    }
//    func fetchPokemonRockType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.rock)"
//        performRequestRock(with:urlString)
//    }
//    func fetchPokemonBugType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.bug)"
//        performRequestBug(with:urlString)
//    }
//    func fetchPokemonGhostType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.ghost)"
//        performRequestGhost(with:urlString)
//    }
//    func fetchPokemonSteelType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.steel)"
//        performRequestSteel(with:urlString)
//    }
//    func fetchPokemonFireType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.fire)"
//        performRequestFire(with:urlString)
//    }
//    func fetchPokemonWaterType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.water)"
//        performRequestWater(with:urlString)
//    }
//    func fetchPokemonGrassType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.grass)"
//        performRequestGrass(with:urlString)
//    }
//    func fetchPokemonElectricType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.electric)"
//        performRequestElectric(with:urlString)
//    }
//    func fetchPokemonPsychicType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.psychic)"
//        performRequestPsychic(with:urlString)
//    }
//    func fetchPokemonIceType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.ice)"
//        performRequestIce(with:urlString)
//    }
//    func fetchPokemonDragonType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.dragon)"
//        performRequestDragon(with:urlString)
//    }
//    func fetchPokemonDarkType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.dark)"
//        performRequestDark(with:urlString)
//    }
//    func fetchPokemonFairyType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.fairy)"
//        performRequestFairy(with:urlString)
//    }
//    func fetchPokemonUnknownType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.unknown)"
//        performRequestUnknown(with:urlString)
//    }
//    func fetchPokemonShadowType(){
//        let urlString = "\(pokemonDetailsURL)\(TypeName.shadow)"
//        performRequestShadow(with:urlString)
//    }
//    func performRequestNormal(with urlString:String){
//        AF.request(urlString,
//                   method: .get,
//                   encoding: URLEncoding.queryString,
//                   headers: nil)
//            .validate()
//            .responseDecodable { (response: DataResponse<PokemonTypeData, AFError>) in
//                switch response.result {
//                case .success(let data):
//                    self.delegate?.selectNormalPokemon(self, pokemon: data)
//                case .failure(let error):
//                    self.delegate?.didFailWithError(error: error)
//                }
//            }
//    }
//    func performRequestFight(with urlString:String){
//        AF.request(urlString,
//                   method: .get,
//                   encoding: URLEncoding.queryString,
//                   headers: nil)
//            .validate()
//            .responseDecodable { (response: DataResponse<PokemonTypeData, AFError>) in
//                switch response.result {
//                case .success(let data):
//                    self.delegate?.selectFightPokemon(self, pokemon: data)
//                case .failure(let error):
//                    self.delegate?.didFailWithError(error: error)
//                }
//            }
//    }
//    
//}
//
//
