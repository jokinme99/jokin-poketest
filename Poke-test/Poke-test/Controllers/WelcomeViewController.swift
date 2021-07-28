//
//  ViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 7/7/21.
//

import UIKit
import CoreData
class WelcomeViewController:UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var pokemonListManager = PokemonListManager()
    var pokemonNames : [Results] = []
    var filteredPokemonNames: [Results] = []
    var searchActive : Bool = false
    
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var pokemonSelected: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonListManager.delegate = self
        loadPokemonList()
        searchBar.delegate = self
        
    }
    //MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath)
        //cell.update(pokemon: filtered[indexPath.row])
        cell.textLabel?.text = filtered[indexPath.row].name?.capitalized
        cell.textLabel?.textColor = #colorLiteral(red: 0.8489313722, green: 0.0005120488931, blue: 0, alpha: 1)
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
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData) {
        self.pokemon = pokemon.results.sorted(by: {$0.name ?? "" < $1.name ?? ""})
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
        pokemonListManager.fetchPokemonList()
    }
}
