

import UIKit
import CoreData
class WelcomeViewController:UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var pokemonListManager = PokemonListManager()
    var pokemonManager = PokemonManager()
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var pokemonSelected: Results?
    var types: [Results] = []
    var typeSelected: Results?
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonListManager.delegate = self
        pokemonManager.delegate = self
        loadPokemonList()
        searchBar.delegate = self
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        
    }
    //MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        let pokemonName = filtered[indexPath.row].name?.capitalized
        cell.updatePokemonName(pokemonName: pokemonName!)
        cell.updatePokemonType(pokemonType: (typeSelected?.name) ?? "")
        return cell
    }
    
    //MARK: - TableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokemonSelected = filtered[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.selectedPokemon = pokemonSelected?.name
    }
}
//MARK: - PokemonListDelegate Methods
extension WelcomeViewController: PokemonListManagerDelegate{
    func didSelectPokemonType(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData) {
        self.types = pokemon.results//Types
        self.tableView.reloadData()
    }
    
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData) {
        self.pokemon = pokemon.results.sorted(by: {$0.name ?? "" < $1.name ?? ""})//Names
        self.filtered = self.pokemon
        self.tableView.reloadData()
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - SearchBarDelegate Methods
extension WelcomeViewController:UISearchBarDelegate{// This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            self.filtered = self.pokemon
        } else {
            self.filtered = self.pokemon.filter({ pokemon in
                guard let name = pokemon.name else { return false }
                return name.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}
//MARK: - Data Manipulation Methods
extension WelcomeViewController{
    func loadPokemonList(){
        pokemonListManager.fetchPokemonList()//List of names
        pokemonListManager.fetchPokemonType()//List of Types
        if let namePokemon = pokemonSelected?.name{
            pokemonManager.fetchPokemon(namePokemon: namePokemon)
        }else{return}
    }
}
//Check Type of pokemon
//MARK: - Type pokemon check methods
extension WelcomeViewController: PokemonManagerDelegate{
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData) {
        self.typeSelected?.name = pokemon.types[0].type.name
    }
    
    func checkType(){//Si la lista de los pokemons tiene un pokemon que tenga ese tipo se pinta de x color
        //pokemon: Results[](Contiene todos los nombres)-> Buscar este pokemon y conseguir su tipo, guardar el tipo en una variable y cambiar el color de la celda
        
    }
}
