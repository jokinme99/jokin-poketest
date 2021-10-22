
import UIKit

//MARK: - ViewControllerDelegate methods
protocol PokemonDetailsViewDelegate: AnyObject {
    var presenter: PokemonDetailsPresenterDelegate? {get set}
    func updateDetailsView(pokemon: PokemonData)
    func updateDetailsViewFavourites(favourites: [Results])//When fetching favourites
    func addFavourite(pokemon: Results)
    func deleteFavourite(pokemon: Results)
    func getSelectedPokemon(with pokemon: Results)
}

//MARK: - SceneController methods: Connections between .xib
protocol PokemonDetailsWireframeDelegate: AnyObject {
    static func createPokemonDetailsModule(pokemon: Results, nextPokemon: Results, previousPokemon: Results, filtered: [Results]) -> UIViewController
}

//MARK: - PresenterDelegate methods: Connection between methods
protocol PokemonDetailsPresenterDelegate: AnyObject {
    var view: PokemonDetailsViewDelegate? {get set}
    var interactor: PokemonDetailsInteractorDelegate? {get set}
    var wireframe: PokemonDetailsWireframeDelegate? {get set}
    func fetchPokemon(pokemon: Results)
    func fetchFavourites()//Check if the pokemon is in the fetched favourites
    func addFavourite(pokemon: Results)
    func deleteFavourite(pokemon: Results)
}

//MARK: - InteractorDelegate methods: Methods that do the functionality
protocol PokemonDetailsInteractorDelegate: AnyObject {
    var presenter: PokemonDetailsInteractorOutputDelegate? {get set}
    var dataBaseDelegate: DDBBManagerDelegate? {get set}
    func fetchPokemon(pokemon: Results)
    func fetchFavouritePokemons()
    func addFavourite(pokemon: Results)
    func deleteFavourite(pokemon: Results)
}

//MARK: - InteractorDelegate methods: Methods that do the functionality
protocol PokemonDetailsInteractorOutputDelegate: AnyObject {
    func didFetchPokemon(pokemon: PokemonData)
    func didFailWithError(error: Error)
    func didFetchFavourites(_ favourites: [Results])
    func didAddFavourite(pokemon: Results)
    func didAddFavouriteWithError(error: Error?)
    func didDeleteFavourite(pokemon: Results)
    func didDeleteFavouriteWithError(error: Error?)
    func didIsSaved(saved: Bool)
    func didGetSelectedPokemon(with pokemon: Results)
}
