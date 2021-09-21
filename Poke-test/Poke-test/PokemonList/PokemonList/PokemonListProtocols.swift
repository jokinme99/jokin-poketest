//
//  PokemonListProtocols.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit
import RealmSwift


protocol PokemonListCellDelegate: AnyObject{ // TableView cell
    var presenter: PokemonListPresenterDelegate? {get set}
    func checkIfFavouritePokemon(pokemonName: String)// Checks if it's a favourite
    func updatePokemonInCell(pokemonToFetch: Results) //Update pokemon in cell
    //func updatePokemonCellData(pokemon: PokemonData) //Update pokemons's type and id

}

protocol PokemonListViewDelegate: AnyObject { // What will appear in the screen
    var presenter: PokemonListPresenterDelegate? {get set}
    func updateTableView(pokemons: PokemonListData) // Update tableView after fetching pokemon list
    func updateTableViewFavourites() // Update tableView after fetching favourites list(When added or deleted a star is highlighted in the cell-> to be able to see the star, the table needs to be reloaded)
    func updateFavouritesFetchInCell(favourites: [Results])
    func updateDetailsFetchInCell(pokemon: PokemonData)
}

protocol PokemonListWireframeDelegate: AnyObject { // Connection with the other .xib
    static func createPokemonListModule() -> UIViewController // To create the window
    func openPokemonDetailsWindow(with pokemon: Results) // Needs a pokemon to open the details page of the selected pokemon
}

protocol PokemonListPresenterDelegate: AnyObject { // Connection between everything(interactor, view and wireframe)
    var cell: PokemonListCellDelegate? {get set}
    var view: PokemonListViewDelegate? {get set}
    var interactor: PokemonListInteractorDelegate? {get set}
    var wireframe: PokemonListWireframeDelegate? {get set}
    func fetchPokemonList() // Connect the fetching of the pokemon list to the view
    func fetchFavourites() // Connect the fetching of the favourites list to the cell
    func openPokemonDetail(with selectedPokemon: Results) // Send the selected pokemon/cell to the wireframe
    func fetchPokemonDetails(pokemon: Results)
}

//Interactor makes all the fetchings
protocol PokemonListInteractorDelegate: AnyObject { // Methods sent FROM the presenter to make the fetching
    var presenter: PokemonListInteractorOutputDelegate? {get set}
    func fetchPokemonList() //Fetch the pokemon list
    func fetchFavouritePokemons() //Fetch the favourites list
    func fetchPokemonDetails(pokemon: Results)
}

protocol PokemonListInteractorOutputDelegate: AnyObject { // Methods sent TO the presenter with the results of the fetching
    func didFetchPokemonList(pokemon: PokemonListData)
    func didFailWith(error: Error)
    func didFetchFavourites(favourites: [Results])
    func didFetchPokemonDetails(pokemon: PokemonData)
}

