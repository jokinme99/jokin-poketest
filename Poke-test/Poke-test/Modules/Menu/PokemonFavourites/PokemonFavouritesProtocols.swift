import UIKit

//MARK: - PokemonFavouritesViewDelegate
protocol PokemonFavouritesViewDelegate: AnyObject {
    var presenter: PokemonFavouritesPresenterDelegate? {get set}
    func updateTableViewFavourites()
    func updateFavouritesFetchInCell(favourites: [Favourites])
    func updateFiltersTableView(pokemons: PokemonFilterListData)
    func deleteFavourite(pokemon: Results)
}


//MARK: - PokemonFavouritesWireframeDelegate
protocol PokemonFavouritesWireframeDelegate: AnyObject {
    static func createPokemonFavouritesModule() -> UIViewController
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
    func openPokemonListWindow()
}


//MARK: - PokemonFavouritesPresenterDelegate
protocol PokemonFavouritesPresenterDelegate: AnyObject {
    var cell: PokemonListCellDelegate? {get set}
    var view: PokemonFavouritesViewDelegate? {get set}
    var interactor: PokemonFavouritesInteractorDelegate? {get set}
    var wireframe: PokemonFavouritesWireframeDelegate? {get set}
    func fetchFavourites()
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
    func openPokemonListWindow()
    func fetchPokemonType(type: String)
    func deleteFavourite(pokemon: Results)
}


//MARK: - PokemonFavouritesInteractorDelegate
protocol PokemonFavouritesInteractorDelegate: AnyObject {
    var presenter: PokemonFavouritesInteractorOutputDelegate? {get set}
    func fetchFavouritePokemons()
    func fetchPokemonType(type:String)
    func deleteFavourite(pokemon: Results)
}


//MARK: - PokemonFavouritesInteractorOutputDelegate
protocol PokemonFavouritesInteractorOutputDelegate: AnyObject {
    func didFailWith(error: Error)
    func didFetchFavourites(favourites: [Favourites])
    func didFetchType(pokemons: PokemonFilterListData)
    func didDeleteFavourite(pokemon: Results)
    func didIsSaved(saved: Bool)
    func didDeleteFavouriteWithError(error: Error?)
}
