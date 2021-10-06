
import UIKit
import RealmSwift

//MARK: - CellDelegate methods
protocol PokemonListCellDelegate: AnyObject{
    var presenter: PokemonListPresenterDelegate? {get set}
    func checkIfFavouritePokemon(pokemonToCheck: Results)
    func updatePokemonInCell(pokemonToFetch: Results)
}

//MARK: - ViewControllerDelegate methods
protocol PokemonListViewDelegate: AnyObject {
    var presenter: PokemonListPresenterDelegate? {get set}
    func updateTableView(pokemons: PokemonListData)
    func updateTableViewFavourites()
    func updateFavouritesFetchInCell(favourites: [Results])
    func updateFiltersTableView(pokemons: PokemonFilterListData)
}

//MARK: - SceneController methods: Connections between .xib
protocol PokemonListWireframeDelegate: AnyObject {
    static func createPokemonListModule() -> UIViewController
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results)
}

//MARK: - PresenterDelegate methods: Connection between methods
protocol PokemonListPresenterDelegate: AnyObject {
    var cell: PokemonListCellDelegate? {get set}
    var view: PokemonListViewDelegate? {get set}
    var interactor: PokemonListInteractorDelegate? {get set}
    var wireframe: PokemonListWireframeDelegate? {get set}
    func fetchPokemonList()
    func fetchFavourites()
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results)
    func fetchPokemonType(type: String)
}

//MARK: - InteractorDelegate methods: Methods that do the functionality
protocol PokemonListInteractorDelegate: AnyObject {
    var presenter: PokemonListInteractorOutputDelegate? {get set}
    func fetchPokemonList()
    func fetchFavouritePokemons()
    func fetchPokemonType(type:String)
}

//MARK: - InteractorOutPutDelegate methods: Methods that send the data received from the InteractorDelegate methods
protocol PokemonListInteractorOutputDelegate: AnyObject {
    func didFetchPokemonList(pokemon: PokemonListData)
    func didFailWith(error: Error)
    func didFetchFavourites(favourites: [Results])
    func didFetchType(pokemons: PokemonFilterListData)
}

