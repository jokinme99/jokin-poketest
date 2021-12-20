import UIKit


//MARK: - PokemonCollectionViewDelegate methods
protocol PokemonCollectionViewDelegate: AnyObject {
    var presenter: PokemonCollectionPresenterDelegate? {get set}
    func updateListCollectionView(pokemons: PokemonListData)
    func updateFavouritesCollectionView(favourites: [Favourites])
    func updateFiltersCollectionView(pokemons: PokemonFilterListData)
    func updateCollectionView()
}


//MARK: - PokemonCollectionWireframeDelegate methods
protocol PokemonCollectionWireframeDelegate: AnyObject {
    static func createPokemonCollectionModule() -> UIViewController
    func openPokemonDetailsWindow(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
}


//MARK: - PokemonCollectionPresenterDelegate methods
protocol PokemonCollectionPresenterDelegate: AnyObject {
    var view: PokemonCollectionViewDelegate? {get set}
    var interactor: PokemonCollectionInteractorDelegate? {get set}
    var wireframe: PokemonCollectionWireframeDelegate? {get set}
    func fetchPokemonList()
    func fetchFavourites()
    func fetchPokemonType(type: String)
    func addFavourite(pokemon: Results)
    func openPokemonDetail(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results])
    func openLoginSignUpWindow()
}


//MARK: - PokemonCollectionInteractorDelegate methods
protocol PokemonCollectionInteractorDelegate: AnyObject {
    var presenter: PokemonCollectionInteractorOutputDelegate? {get set}
    func fetchPokemonList()
    func fetchFavourites()
    func fetchPokemonType(type: String)
    func addFavourite(pokemon: Results)
}


//MARK: - PokemonCollectionInteractorOutputDelegate methods
protocol PokemonCollectionInteractorOutputDelegate: AnyObject {
    func didFetchPokemonList(pokemon: PokemonListData)
    func didFetchFavourites(favourites: [Favourites])
    func didFetchType(pokemons: PokemonFilterListData)
    func didFailWith(error: Error)
    func didAddFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
}
