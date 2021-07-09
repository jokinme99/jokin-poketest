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
    var pokemonNames = [String]()//List of pokemon names
    var filteredPokemonNames: [String] = []//List of pokemon names searched
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonListManager.delegate = self
        loadPokemonList()
        searchBar.delegate = self
        
        
    }
    //MARK: - TableViewDataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(searchActive) {
            return filteredPokemonNames.count
        }
        return pokemonNames.count;
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath)
        if(searchActive){
            cell.textLabel?.text = filteredPokemonNames.sorted(by: <)[indexPath.row].uppercased()
        } else {
            cell.textLabel?.text = pokemonNames.sorted(by: <)[indexPath.row].uppercased()
        }
        return cell
    }
    
    //MARK: - TableViewDelegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            if (searchActive){
                destinationVC.selectedPokemon = filteredPokemonNames.sorted(by: <)[indexPath.row]
            }else{
                destinationVC.selectedPokemon = pokemonNames.sorted(by: <)[indexPath.row]//pokemon/row selected
                
            }
        }
    }
}
//MARK: - PokemonListDelegate Methods
extension WelcomeViewController: PokemonListManagerDelegate{
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListModel) {
        DispatchQueue.main.async {
            for data in pokemon.names{//Save in the array of the pokemon names
                self.pokemonNames.append(data)
            }
            self.tableView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - SearchBarDelegate Methods
extension WelcomeViewController:UISearchBarDelegate{// This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredPokemonNames = pokemonNames.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filteredPokemonNames.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
}
//MARK: - Data Manipulation Methods
extension WelcomeViewController{
    func loadPokemonList(){
        pokemonListManager.fetchPokemonList()//Make the call
        //didUpdatePokemonList(pokemonListManager, pokemon: PokemonListModel(names: pokemonNames))//Save the PokemonListManager array into pokemonNames array
        
    }
    func saveSelection(){
        
    }
}
