
import UIKit
import NotificationCenter
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase

class PokemonFavouritesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var buttonList: [UIButton]!
    @IBOutlet weak var orderBySearchView: UIView!
    
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var savefilteredOrder : [Results] = []
    var pokemonSelected: Results?
    var cell = PokemonCell()
    var presenter: PokemonFavouritesPresenterDelegate?
    var pokemonInCell: Results?
    var nextPokemon: Results?
    var previousPokemon: Results?
    var detailsPresenter: PokemonDetailsPresenter?
    var pokemonDataList: [PokemonData] = []
    var dictionaryIdResults: [Results:Int]?
    var dictionary: [PokemonDictionary] = []
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
        loadDelegates()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        presenter?.fetchFavourites()
        loadButtons()
        loadSearchBar()
        tableView.rowHeight = 80.0
        pokemonDataList = DDBBManager.shared.get(PokemonData.self)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        presenter?.fetchFavourites()
        for filter in filtered{
            if filter.isInvalidated{
                filtered.removeAll()
                pokemon.removeAll()
                savefilteredOrder.removeAll()
                presenter?.fetchFavourites()
            }
        }
    }
    
}
//MARK: - ViewDidLoad Methods
extension PokemonFavouritesViewController{
    func loadDelegates(){
        searchBar.delegate = self
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
    func loadSearchBar(){
        self.searchBar.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

//MARK: - ViewControllerDelegate methods
extension PokemonFavouritesViewController: PokemonFavouritesViewDelegate {
    
    //MARK: - Delete favourites method
    func deleteFavourite(pokemon: Results) {
        presenter?.fetchFavourites()
    }
    
    
    //MARK: - Updates filters
    func updateFiltersTableView(pokemons: PokemonFilterListData) {
        presenter?.fetchFavourites()
        let saveFiltered = self.filtered
        filtered.removeAll()
        pokemon.removeAll()
        savefilteredOrder.removeAll()
        for pokemonType in pokemons.pokemon{
            for filter in saveFiltered{
                if filter.name == pokemonType.pokemon?.name{
                    pokemon.append(filter)
                    filtered.append(filter)
                    savefilteredOrder.append(filter)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    //MARK: - Updates the favourite list after the fetching
    func updateFavouritesFetchInCell(favourites: [Favourites]) {//Make it work if offline
        if user != nil{
            if favourites.isEmpty{
                let alert = UIAlertController(title: "Favourites", message: "You haven't added any favourites yet. Would you like to see all the available Pokemon, in order to add any of them?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {(action) in
                    self.presenter?.openPokemonListWindow()
                }))
                alert.addAction(UIAlertAction(title: "Maybe later", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            if filtered.isEmpty && pokemon.isEmpty{
                for favourite in favourites {
                    self.pokemon.append(Results(name: favourite.name ?? "default"))
                }
                self.filtered = self.pokemon
                self.savefilteredOrder = self.pokemon
                sortFilteredOrdered()
                self.tableView.reloadData()
            }else{
                pokemon.removeAll()
                filtered.removeAll()
                savefilteredOrder.removeAll()
                for favourite in favourites {
                    self.pokemon.append(Results(name: favourite.name ?? "default"))
                }
                self.filtered = self.pokemon
                self.savefilteredOrder = self.pokemon
                sortFilteredOrdered()
                self.tableView.reloadData()
            }
        }else{
            //not logged
            let alert = UIAlertController(title: "Favourites", message: "You will not be able to add any pokemons to favourites until you login or sign up. Would you like to login or sign up?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {(action) in
                self.presenter?.openLoginSignUpWindow()
            }))
            alert.addAction(UIAlertAction(title: "Maybe later", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    //MARK: - Updates tableView after adding/deleting favourites
    func updateTableViewFavourites() {//Make it work if offline
        self.tableView.reloadData()
    }
}

//MARK: - TableView Methods
extension PokemonFavouritesViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count; //Row count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        pokemonInCell = filtered[indexPath.row]
        cell.updatePokemonInCell(pokemonToFetch: pokemonInCell!)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let previousRow = row - 1
        let nextRow = row + 1
        if filtered.count == 1{
            pokemonSelected = filtered[row]
            nextPokemon = Results()
            previousPokemon = Results()
        }else{
            if row == 0{
                pokemonSelected = filtered[row]
                nextPokemon = filtered[nextRow]
                previousPokemon = filtered.last
            }else if row == filtered.count - 1{
                pokemonSelected = filtered[row]
                previousPokemon = filtered[previousRow]
                nextPokemon = filtered.first
            }else{
                nextPokemon = filtered[nextRow]
                pokemonSelected = filtered[row]
                previousPokemon = filtered[previousRow]
            }
        }
        presenter?.openPokemonDetail(pokemon: pokemonSelected!, nextPokemon: nextPokemon!, previousPokemon: previousPokemon!, filtered: filtered)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.presenter?.deleteFavourite(pokemon: filtered[indexPath.row])
        }
    }
    
}

//MARK: - SearchBar Delegate & bookmark buttons methods
extension PokemonFavouritesViewController:UISearchBarDelegate{
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
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {//If it has value
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}


//MARK: - OrderBy Buttons methods
extension PokemonFavouritesViewController{
    
    @objc func pressedOrderBy(_ sender: UIButton!) {
        if orderByButton.titleLabel?.text == "Order by Name"{
            orderByButton.setTitle("Order by Id", for: .normal)
            self.filtered = filtered.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.tableView.reloadData()
        }
        else{
            orderByButton.setTitle("Order by Name", for: .normal)
            sortFilteredOrdered()
            
        }
    }
    func sortFilteredOrdered(){
        dictionary.removeAll()
        for pokemonInDataList in pokemonDataList.sorted(by: {$0.id < $1.id}){
            for pok in filtered{
                if pok.name == pokemonInDataList.name{
                    dictionary.append(PokemonDictionary(pokemonInDict: pok, pokemonId: pokemonInDataList.id))
                }
            }
        }
        filtered.removeAll()
        for sort in dictionary{
            filtered.append(sort.pokemonInDict!)
        }
        self.tableView.reloadData()
    }
}

//MARK: - Filter Buttons methods
extension PokemonFavouritesViewController{
    @objc func pressedFilterButton(_ sender: UIButton!){
        switch sender.titleLabel?.text?.lowercased(){
        case "all":
            cleanSearchBar()
            self.presenter?.fetchFavourites()
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
extension PokemonFavouritesViewController{
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
