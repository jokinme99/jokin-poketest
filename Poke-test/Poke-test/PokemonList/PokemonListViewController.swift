
import UIKit

//ToDo: IN FAVS WHEN DELETING APP BREAKS
//Todo: IN ORDERBY IT HAS TO BE ORDERED BY ID
//Orders the list as the pokemon are added/fetched if #12 is added to favs before #1 favourites[0] is #12 and not #1

class PokemonListViewController: UIViewController {//PIN iPhone: 281106
    
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
    var nextPokemon: Results?
    var previousPokemon: Results?
    //var pokemonIdAndNames: [Int : String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
        presenter?.fetchPokemonList()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        presenter?.fetchFavourites()
        navigationItem.title = "Pokedex"
        loadButtons()
        loadSearchBarAndKeyboard()
    }
    override func viewWillAppear(_ animated: Bool) {
        presenter?.fetchFavourites()
    }
    
}

//MARK: - ViewDidLoad Methods
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
    func loadSearchBarAndKeyboard(){
        let imageBookmark = imageWithImage(image: UIImage(named: "redStar")!, scaledToSize: CGSize(width: 20, height: 20))
        self.searchBar.setImage(imageBookmark, for: .bookmark, state: .normal)
        searchBar.addDoneButtonOnKeyboard()
    }
}

//MARK: - ViewControllerDelegate methods
extension PokemonListViewController: PokemonListViewDelegate {
    //MARK: - Updates filters
    func updateFiltersTableView(pokemons: PokemonFilterListData) {
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
        }
        else{
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
        let row = indexPath.row
        let previousRow = row - 1
        let nextRow = row + 1
        if row == 0{
            pokemonSelected = filtered[row]
            nextPokemon = filtered[nextRow]
            previousPokemon = filtered.last
        }else if row == filtered.count - 1{ //-1 -> the 0 position is the first row
            pokemonSelected = filtered[row]
            previousPokemon = filtered[previousRow]
            nextPokemon = filtered.first
        }else{
            nextPokemon = filtered[nextRow] 
            pokemonSelected = filtered[row]
            previousPokemon = filtered[previousRow]
        }
        presenter?.openPokemonDetail(pokemon: pokemonSelected!, nextPokemon: nextPokemon!, previousPokemon: previousPokemon!, filtered: filtered)
        
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
            self.savefilteredOrder = favouritesList
            self.pokemon = favouritesList
            self.tableView.reloadData()
        }else{
            presenter?.fetchPokemonList()
        }
        
        
    }
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
    
}
//MARK: - Done button in keyboard methods
extension UISearchBar{

      @IBInspectable var doneAccessory: Bool{
          get{
              return self.doneAccessory
          }
          set (hasDone) {
              if hasDone{
                  addDoneButtonOnKeyboard()
              }
          }
      }

      func addDoneButtonOnKeyboard()
      {
          let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
          doneToolbar.barStyle = .default

          let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
          let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

          let items = [flexSpace, done]
          doneToolbar.items = items
          doneToolbar.sizeToFit()

          self.inputAccessoryView = doneToolbar
      }

      @objc func doneButtonAction() {
          self.resignFirstResponder()
      }

  }

//MARK: - OrderBy Buttons methods
extension PokemonListViewController{
    
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
