

import UIKit
import CoreData
class WelcomeViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: UIButton!
    
    var pokemonListManager = PokemonListManager()
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var savefilteredOrder : [Results] = []
    var pokemonSelected: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonListManager.delegate = self
        loadPokemonList()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        orderByButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
    }
}
extension WelcomeViewController:UITableViewDelegate, UITableViewDataSource{
    //MARK: - TableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        let pokemon = filtered[indexPath.row]
        cell.update(pokemon: pokemon)
        return cell
    }
    
    //MARK: - TableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        self.pokemon = pokemon.results
        self.filtered = self.pokemon
        self.savefilteredOrder = self.pokemon
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
            self.savefilteredOrder = self.pokemon
        } else {
            self.filtered = self.pokemon.filter({ pokemon in
                guard let name = pokemon.name else { return false }
                return name.lowercased().contains(searchText.lowercased())
            })
            self.savefilteredOrder = self.pokemon.filter({ pokemon in //For when searching a pokemon have the possibility to order the list
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
    }
}
//MARK: - Button Handling Methods
extension WelcomeViewController{
    @objc func pressed(_ sender: UIButton!) {
        if orderByButton.titleLabel?.text == "Order by Name"{
            orderByButton.setTitle("Order by Id", for: .normal)
            self.filtered = filtered.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.tableView.reloadData()
        }
        if orderByButton.titleLabel?.text == "Order by Id"{
            orderByButton.setTitle("Order by Name", for: .normal)
            self.filtered = self.savefilteredOrder
            
            self.tableView.reloadData()
        }
        
    }
}
