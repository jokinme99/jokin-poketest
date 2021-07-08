//
//  PokemonManager.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import Foundation
//2ND API, BEFORE YOU HAVE TO LOOK THE POKEMON LIST FROM https://pokeapi.co/api/v2/pokemon/?limit=50
protocol  PokemonManagerDelegate {
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonModel)
    func didFailWithError(error:Error)
}


struct PokemonManager{
    //let pokemonListURL = "https://pokeapi.co/api/v2/pokemon/?limit=50"
    let pokemonDetailsURL = "https://pokeapi.co/api/v2/pokemon/"
    
    var delegate: PokemonManagerDelegate?

    func fetchPokemon(namePokemon: String){
        let urlString = "\(pokemonDetailsURL)\(namePokemon)"
        performRequest(with:urlString)
    }
        func performRequest(with urlString:String){
            //1. Create a URL
            if let url = URL(string: urlString){
                //2. Create a URL session
                let session = URLSession(configuration: .default)
                //3. Give the session a task
                let task = session.dataTask(with: url) { data, response, error in
                    if error != nil{
                        self.delegate?.didFailWithError(error: error!)
                        return
                    }
                    if let safeData = data{
                        if let pokemon = self.parseJSON(safeData){
                            self.delegate?.didUpdatePokemon(self, pokemon:pokemon)
                        }
                    }
                }
                //4. Start a task
                task.resume()
            }
        }
    func parseJSON(_ pokemonData: Data)->PokemonModel?{
            let decoder = JSONDecoder()
            do{
               let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
                print("Name: \(decodedData.name), Image: \(decodedData.sprites.front_default)")//Image's url
                let name = decodedData.name
                let image = decodedData.sprites.front_default
    
                let pokemon = PokemonModel(namePokemon: name, imagePokemon: image)
    
                return pokemon
            }catch{
                self.delegate?.didFailWithError(error: error)
                return nil
            }
    
        }
    
}


//    func performRequest(with urlString:String){
//        //1. Create a URL
//        if let url = URL(string: urlString){
//            //2. Create a URL session
//            let session = URLSession(configuration: .default)
//            //3. Give the session a task
//            let task = session.dataTask(with: url) { data, response, error in
//                if error != nil{
//                    self.delegate?.didFailWithError(error: error!)
//                    return
//                }
//                if let safeData = data{
//                    if let weather = self.parseJSON(safeData){
//                        self.delegate?.didUpdateWeather(self, weather:weather)//Referencia a la clase(.swift)
//                    }
//                }
//            }
//            //4. Start a task
//            task.resume()
//        }
//    }
//    func parseJSON(_ weatherData: Data)->WeatherModel?{//_ espacio : sirve para omitir el nombre luego
//        let decoder = JSONDecoder()
//        do{
//           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
//            print("Temperature: \(decodedData.main.temp), Comment: \(decodedData.weather[0].description)")
//            let id = decodedData.weather[0].id
//            let temp = decodedData.main.temp
//            let name = decodedData.name
//
//            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
//
//            print(weather.conditionName)
//            print(weather.temperatureString)
//            return weather
//        }catch{
//            self.delegate?.didFailWithError(error: error)
//            return nil
//        }
//
//    }
//
//}
