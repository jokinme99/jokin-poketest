
import UIKit

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var savefilteredOrder : [Results] = []
    var pokemonSelected: Results?
    var cell = PokemonCell()
    var cellDelegate: PokemonListCellDelegate?
    var presenter: PokemonListPresenterDelegate?
    var favouritesList: [Results] = []
    var pokemonInCell: Results?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
        presenter?.fetchPokemonList()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        orderByButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        presenter?.fetchFavourites()
    }
    override func viewWillAppear(_ animated: Bool) {
        //When adding/deleting a pokemon the favourites list & the tableView have to load again
        presenter?.fetchFavourites()
    }
}

//MARK: - ViewControllerDelegate methods
extension PokemonListViewController: PokemonListViewDelegate {
    
    //MARK: - Updates the favourite list after the fetching
    func updateFavouritesFetchInCell(favourites: [Results]) {
        self.favouritesList = favourites
        
    }
    
    //MARK: - Updates tableView after adding/deleting favourites
    func updateTableViewFavourites() {
        self.tableView.reloadData()
    }
    
    //MARK: - Updates tableView after fetching pokemon list
    func updateTableView(pokemons: PokemonListData) {
        self.pokemon = Array(pokemons.results)
        self.filtered = self.pokemon
        self.savefilteredOrder = self.pokemon
        self.tableView.reloadData()
    }
}


//MARK: - TableView Methods
extension PokemonListViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count; //Row count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        pokemonInCell = filtered[indexPath.row]
        cell.favouritesList = favouritesList
        cell.updatePokemonInCell(pokemonToFetch: pokemonInCell!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokemonSelected = filtered[indexPath.row]
        presenter?.openPokemonDetail(with: pokemonSelected!)//It works
    }
    
}
//MARK: - SearchBar Delegate methods
extension PokemonListViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            self.filtered = self.pokemon
            self.savefilteredOrder = self.pokemon
        } else {
            self.filtered = self.pokemon.filter({ pokemon in
                guard let name = pokemon.name else { return false }
                return name.lowercased().contains(searchText.lowercased())
            })
            self.savefilteredOrder = self.pokemon.filter({ pokemon in
                guard let name = pokemon.name else { return false }
                return name.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
}
//MARK: - OrderBy Buttons methods
extension PokemonListViewController{
    @objc func pressed(_ sender: UIButton!) {
        if orderByButton.titleLabel?.text == "Order by Name"{
            orderByButton.setTitle("Order by Id", for: .normal)
            self.filtered = filtered.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.tableView.reloadData()
        }
        else{
            orderByButton.setTitle("Order by Name", for: .normal)
            self.filtered = self.savefilteredOrder
            self.tableView.reloadData()
        }
        
    }
}

//MARK: - Data Manipulation Methods
extension PokemonListViewController{
    func loadDelegates(){
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}
