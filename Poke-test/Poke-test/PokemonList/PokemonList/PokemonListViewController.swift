
import UIKit

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var buttonList: [UIButton]!
    
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var savefilteredOrder : [Results] = []
    var pokemonSelected: Results?
    var cell = PokemonCell()
    var presenter: PokemonListPresenterDelegate?
    var favouritesList: [Results] = []
    var pokemonInCell: Results?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
        presenter?.fetchPokemonList()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        presenter?.fetchFavourites()
        navigationItem.title = "Pokedex"
        loadButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        //When adding/deleting a pokemon the favourites list & the tableView have to load again
        presenter?.fetchFavourites()
    }
}

//MARK: - ViewControllerDelegate methods
extension PokemonListViewController: PokemonListViewDelegate {
    func updateFiltersTableView(pokemons: PokemonFilterListData) {//WORKS
        self.pokemon.removeAll()
        self.filtered.removeAll()
        for pokemonType in pokemons.pokemon{
            pokemon.append(Results(name: pokemonType.pokemon.name))
            filtered.append(Results(name: pokemonType.pokemon.name))
        }
        self.tableView.reloadData()
    }
    
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
        if filtered.isEmpty && pokemon.isEmpty{
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.savefilteredOrder = self.pokemon
            self.tableView.reloadData()
        }else{
            pokemon.removeAll()
            filtered.removeAll()
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.savefilteredOrder = self.pokemon
            self.tableView.reloadData()
        }
        
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
//MARK: - SearchBar Delegate & bookmark buttons methods
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
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if filtered != favouritesList{
            self.filtered = favouritesList
            self.tableView.reloadData()
        }else{
            presenter?.fetchPokemonList()
        }
        
    }
    
    
}
//MARK: - OrderBy Buttons methods
extension PokemonListViewController{//Order by buttons when pressing order by not working
    
    @objc func pressedOrderBy(_ sender: UIButton!) {
        if orderByButton.titleLabel?.text == "Order by Name"{
            orderByButton.setTitle("Order by Id", for: .normal)
            self.filtered = filtered.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.tableView.reloadData()
        }
        else{
            orderByButton.setTitle("Order by Name", for: .normal)
            if searchBar.text?.isEmpty == true{
                self.filtered = self.pokemon
            }else{
                self.filtered = self.savefilteredOrder
            }
             
            self.tableView.reloadData()
        }
        
    }
}

//MARK: - Filter Buttons methods
extension PokemonListViewController{
    @objc func pressedFilterButton(_ sender: UIButton!){
        switch sender.titleLabel?.text?.lowercased(){
        case "all":
            cleanSearchBar()
            self.presenter?.fetchPokemonList()
        case TypeName.normal:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.normal)
        case TypeName.fight:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.fight)
        case TypeName.flying:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.flying)
        case TypeName.poison:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.poison)
        case TypeName.ground:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.ground)
        case TypeName.rock:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.rock)
        case TypeName.bug:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.bug)
        case TypeName.ghost:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.ghost)
        case TypeName.steel:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.steel)
        case TypeName.fire:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.fire)
        case TypeName.water:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.water)
        case TypeName.grass:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.grass)
        case TypeName.electric:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.electric)
        case TypeName.psychic:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.psychic)
        case TypeName.ice:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.ice)
        case TypeName.dragon:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.dragon)
        case TypeName.dark:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.dark)
        case TypeName.fairy:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.fairy)
        case TypeName.unknown: //There exist 0 pokemon with this type
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.unknown)
        case TypeName.shadow:
            cleanSearchBar()
            self.presenter?.fetchPokemonType(type: TypeName.shadow)
        case .none:
            print("Error: .none")
        case .some(_):
            print("Error: .some(_)")
        }
    }
    func cleanSearchBar(){
        if searchBar.text?.isEmpty == false{
            searchBar.text?.removeAll()
        }
    }
    
}

//MARK: - Data Manipulation Methods
extension PokemonListViewController{
    func loadDelegates(){
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    func loadButtons(){
        orderByButton.addTarget(self, action: #selector(pressedOrderBy), for: .touchUpInside)
        for button in buttonList{
            button.addTarget(self, action: #selector(pressedFilterButton), for: .touchUpInside)
            paintButton(button)
        }
        
    }
}
//MARK: - Painting Methods

extension PokemonListViewController{
    func setPokemonTextColor(_ color: UIColor, _ button: UIButton){
        button.titleLabel?.textColor = color
    }
    func setFilterButtonsBackground(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ button: UIButton){
        button.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    func paintButton(_ button: UIButton){
        switch button.titleLabel?.text?.lowercased(){
        case "all":
            button.titleLabel?.textColor = #colorLiteral(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
            setPokemonTextColor(.black, button)
        case TypeName.normal:
            setFilterButtonsBackground(168, 168, 120, button)
            setPokemonTextColor(.white, button)
        case TypeName.fight:
            setFilterButtonsBackground(192, 48, 40, button)
            setPokemonTextColor(.white, button)
        case TypeName.flying:
            setFilterButtonsBackground(168, 144, 240, button)
            setPokemonTextColor(.white, button)
        case TypeName.poison:
            setFilterButtonsBackground(160, 64, 160, button)
            setPokemonTextColor(.white, button)
        case TypeName.ground:
            setFilterButtonsBackground(224, 192, 104, button)
            setPokemonTextColor(.black, button)
        case TypeName.rock:
            setFilterButtonsBackground(184, 160, 56, button)
            setPokemonTextColor(.black, button)
        case TypeName.bug:
            setFilterButtonsBackground(168, 184, 32, button)
            setPokemonTextColor(.white, button)
        case TypeName.ghost:
            setFilterButtonsBackground(112, 88, 152, button)
            setPokemonTextColor(.white, button)
        case TypeName.steel:
            setFilterButtonsBackground(184, 184, 208, button)
            setPokemonTextColor(.black, button)
        case TypeName.fire:
            setFilterButtonsBackground(240, 128, 48, button)
            setPokemonTextColor(.black, button)
        case TypeName.water:
            setFilterButtonsBackground(104, 144, 240, button)
            setPokemonTextColor(.white, button)
        case TypeName.grass:
            setFilterButtonsBackground(120, 200, 80, button)
            setPokemonTextColor(.white, button)
        case TypeName.electric:
            setFilterButtonsBackground(248, 208, 48, button)
            setPokemonTextColor(.black, button)
        case TypeName.psychic:
            setFilterButtonsBackground(248, 88, 136, button)
            setPokemonTextColor(.white, button)
        case TypeName.ice:
            setFilterButtonsBackground(152, 216, 216, button)
            setPokemonTextColor(.black, button)
        case TypeName.dragon:
            setFilterButtonsBackground(112, 56, 248, button)
            setPokemonTextColor(.white, button)
        case TypeName.dark:
            setFilterButtonsBackground(112, 88, 72, button)
            setPokemonTextColor(.white, button)
        case TypeName.fairy:
            setFilterButtonsBackground(238, 153, 172, button)
            setPokemonTextColor(.black, button)
        case TypeName.unknown: //There exits 0 pokemon with this type
            setFilterButtonsBackground(0, 0, 0, button)
            setPokemonTextColor(.white, button)
        case TypeName.shadow:
            setFilterButtonsBackground(124, 110, 187, button)
            setPokemonTextColor(.white, button)
            
        case .none:
            print("There aren't any buttons")
        case .some(_):
            print("Error in some(_)")
            
        }
    }
}
