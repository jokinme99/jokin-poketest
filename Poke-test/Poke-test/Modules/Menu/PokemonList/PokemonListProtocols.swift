import UIKit

//MARK: - CellDelegate methods
protocol PokemonListCellDelegate: AnyObject{
    var presenter: PokemonListPresenterDelegate? {get set}
    func updatePokemonInCell(pokemonToFetch: Results)
}

//MARK: - ViewControllerDelegate methods
protocol PokemonListViewDelegate: AnyObject {
    var presenter: PokemonListPresenterDelegate? {get set}
    func updateTableView(pokemons: PokemonListData)
    func updateFiltersTableView(pokemons: PokemonFilterListData)
    func updateTableView()
//    func addFavourite(pokemon: Results)
    func updateFavourites(favourites: [Favourites])
}

//MARK: - SceneController methods: Connections between .xib
protocol PokemonListWireframeDelegate: AnyObject {
    static func createPokemonListModule() -> UIViewController
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
}

//MARK: - PresenterDelegate methods: Connection between methods
protocol PokemonListPresenterDelegate: AnyObject {
    var cell: PokemonListCellDelegate? {get set}
    var view: PokemonListViewDelegate? {get set}
    var interactor: PokemonListInteractorDelegate? {get set}
    var wireframe: PokemonListWireframeDelegate? {get set}
    func fetchPokemonList()
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func fetchPokemonType(type: String)
    func addFavourite(pokemon: Results)
    func fetchFavourites()
    func openLoginSignUpWindow()
}

//MARK: - InteractorDelegate methods: Methods that do the functionality
protocol PokemonListInteractorDelegate: AnyObject {
    var presenter: PokemonListInteractorOutputDelegate? {get set}
    func fetchPokemonList()
    func fetchPokemonType(type:String)
    func addFavourite(pokemon: Results)
    func fetchFavourites()
}

//MARK: - InteractorOutPutDelegate methods: Methods that send the data received from the InteractorDelegate methods
protocol PokemonListInteractorOutputDelegate: AnyObject {
    func didFetchPokemonList(pokemon: PokemonListData)
    func didFailWith(error: Error)
    func didFetchType(pokemons: PokemonFilterListData)
//    func didAddFavourite(pokemon: Results)//No es necesario porque en la ventana no se va a hacer ningún cambio
    func didAddFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
    func didFetchFavourites(favourites: [Favourites])
}

