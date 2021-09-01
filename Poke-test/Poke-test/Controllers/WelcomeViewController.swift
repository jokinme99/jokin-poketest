
import UIKit

class WelcomeViewController: UIViewController { // Class with an UITableViewController containing all the pokemon names
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: UIButton!
    
    var pokemonListManager = PokemonListManager()
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var savefilteredOrder : [Results] = []
    var pokemonSelected: Results?
    var cell = PokemonCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
        loadPokemonList()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        orderByButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)

    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.updateTableView()
        }
    }
}

//MARK: - TableView Methods
extension WelcomeViewController:UITableViewDelegate, UITableViewDataSource{ // Methods in charge of the UITableViewDelegate methods and the UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        let pokemon = filtered[indexPath.row]
        cell.update(pokemon: pokemon)
        cell.checkFavourite(pokemon.name!)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokemonSelected = filtered[indexPath.row]
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        destinationVC.selectedPokemon = pokemonSelected
    }
}

//MARK: - PokemonListDelegate Methods
extension WelcomeViewController: PokemonListManagerDelegate{ // Method in charge of the PokemonListDelegate protocol
    func didUpdatePokemonList(_ pokemonListManager: PokemonListManager, pokemon: PokemonListData) {
        self.pokemon = Array(pokemon.results)//Expects an array and due to using @objc whe need to use List<>, so we cast it
        self.filtered = self.pokemon
        self.savefilteredOrder = self.pokemon
        self.tableView.reloadData()
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - SearchBarDelegate Methods
extension WelcomeViewController:UISearchBarDelegate{ // Method in charge of updating filteredData based on the text in the Search Box
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
extension WelcomeViewController{ //Method in charge of fetching the list of pokemon and the needed delegates
    func loadPokemonList(){
        pokemonListManager.fetchPokemonList()
    }
    func loadDelegates(){
        pokemonListManager.delegate = self
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        cell.cellManagerDelegate = self
    }
}

//MARK: - Favourites Handling Methods
extension WelcomeViewController{ // Methods in charge of the orderBy buttons
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

//MARK: - Favourites Methods
extension WelcomeViewController: CellManagerDelegate{ // Method in charge of the CellManagerDelegate protocol
    func updateTableView() {
        tableView.reloadData()
    }
    
}
