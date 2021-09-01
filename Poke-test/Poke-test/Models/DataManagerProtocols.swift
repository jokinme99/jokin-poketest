
import UIKit

protocol PokemonListManagerDelegate { //Protocol needed to fetch the pokemon list
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData)
    func didFailWithError(error:Error)
}

protocol PokemonManagerDelegate { //Protocol needed to fetch the pokemon details list
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData)
    func didFailWithError(error:Error)
}

protocol DDBBManagerDelegate:AnyObject{ //Protocol needed to stablish changes in the realm database
    func didSaveFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
    func didDeleteFavouriteWithError(error: Error?)
}

protocol CellManagerDelegate{ // Protocol needed to update the tableView after adding/removing favourites
    func updateTableView()
}
