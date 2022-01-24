
import UIKit
import NotificationCenter
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCrashlytics
import Zero

//MARK: - PokemonListViewController
class PokemonListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: ZeroTextButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var orderBySearchView: UIView!
    @IBOutlet var buttonList: [ZeroContainedButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var presenter: PokemonListPresenterDelegate?
    var pokemon : [Results] = []
    var filtered : [Results] = []
    var saveFilteredOrder : [Results] = []
    var pokemonSelected: Results?
    var cell = PokemonCell()
    var pokemonInCell: Results?
    var nextPokemon: Results?
    var previousPokemon: Results?
    var favourites: [Favourites] = []
    let user = Auth.auth().currentUser
    var all: String?; var normal: String?; var fighting: String?; var flying: String?; var poison: String?; var ground: String?; var rock: String?; var bug: String?; var ghost: String?; var steel: String?; var fire: String?; var water: String?; var grass: String?; var electric: String?; var psychic: String?; var ice: String?; var dragon: String?; var dark: String?; var fairy: String?; var unknown: String?; var shadow: String?
    var alert = ZeroDialog()
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
        loadDelegates()
        loadStyle()
        presenter?.fetchPokemonList()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        loadButtons()
        loadSearchBar()
        crashlyticsErrorSending()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.fetchFavourites()
        for filter in filtered {
            if filter.isInvalidated{
                filtered.removeAll()
                presenter?.fetchPokemonList()
                self.pokemon = filtered
                self.saveFilteredOrder = filtered
            }
        }
    }
    
}


//MARK: - ViewDidLoad Methods
extension PokemonListViewController{
    
    
    //MARK: - loadDelegates
    func loadDelegates(){
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: - loadButtons
    func loadButtons(){
        orderByButton.addTarget(self, action: #selector(pressedOrderBy), for: .touchUpInside)
        for button in buttonList{
            button.addTarget(self, action: #selector(pressedFilterButton), for: .touchUpInside)
            paintButton(button)
        }
        orderByButton.setTitle(NSLocalizedString("Order_by_Name", comment: ""), for: .normal)
        loadFilterButtons()
    }
    
    
    //MARK: - loadStyle
    func loadStyle(){
        tableView.rowHeight = 50.0
        orderBySearchView.layer.cornerRadius = 10
        searchBar.layer.cornerRadius = 5
        tableView.layer.cornerRadius = 5
        scrollView.layer.cornerRadius = 5
        for b in buttonList{
            b.layer.cornerRadius = 1
        }
        orderByButton.style = .normal
        searchBar.searchBarStyle = .minimal
        orderByButton.apply(ZeroTheme.Button.normal)
    }
    
    
    //MARK: - loadSearchBar
    func loadSearchBar(){
        self.searchBar.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        searchBar.placeholder = NSLocalizedString("search_for_pokemons", comment: "")
    }
    
    
    //MARK: - loadFilterButtons
    func loadFilterButtons(){
        all = NSLocalizedString("all", comment: "").lowercased(); normal = NSLocalizedString("normal", comment: "").lowercased(); fighting = NSLocalizedString("fighting", comment: "").lowercased()
        flying = NSLocalizedString("flying", comment: "").lowercased(); poison = NSLocalizedString("poison", comment: "").lowercased(); ground = NSLocalizedString("ground", comment: "").lowercased()
        rock = NSLocalizedString("rock", comment: "").lowercased(); bug = NSLocalizedString("bug", comment: "").lowercased(); ghost = NSLocalizedString("ghost", comment: "").lowercased()
        steel = NSLocalizedString("steel", comment: "").lowercased(); fire = NSLocalizedString("fire", comment: "").lowercased(); water = NSLocalizedString("water", comment: "").lowercased()
        grass = NSLocalizedString("grass", comment: "").lowercased(); electric = NSLocalizedString("electric", comment: "").lowercased(); psychic = NSLocalizedString("psychic", comment: "").lowercased()
        ice = NSLocalizedString("ice", comment: "").lowercased(); dragon = NSLocalizedString("dragon", comment: "").lowercased(); dark = NSLocalizedString("dark", comment: "").lowercased()
        fairy = NSLocalizedString("fairy", comment: "").lowercased(); unknown = NSLocalizedString("unknown", comment: "").lowercased(); shadow = NSLocalizedString("shadow", comment: "").lowercased()
        
        buttonList[0].setTitle(all?.capitalized, for: .normal); buttonList[1].setTitle(normal?.capitalized, for: .normal); buttonList[2].setTitle(fighting?.capitalized, for: .normal)
        buttonList[3].setTitle(flying?.capitalized, for: .normal); buttonList[4].setTitle(poison?.capitalized, for: .normal); buttonList[5].setTitle(ground?.capitalized, for: .normal)
        buttonList[6].setTitle(rock?.capitalized, for: .normal); buttonList[07].setTitle(bug?.capitalized, for: .normal); buttonList[8].setTitle(ghost?.capitalized, for: .normal)
        buttonList[9].setTitle(steel?.capitalized, for: .normal); buttonList[10].setTitle(fire?.capitalized, for: .normal); buttonList[11].setTitle(water?.capitalized, for: .normal)
        buttonList[12].setTitle(grass?.capitalized, for: .normal); buttonList[13].setTitle(electric?.capitalized, for: .normal); buttonList[14].setTitle(psychic?.capitalized, for: .normal)
        buttonList[15].setTitle(ice?.capitalized, for: .normal); buttonList[16].setTitle(dragon?.capitalized, for: .normal); buttonList[17].setTitle(dark?.capitalized, for: .normal)
        buttonList[18].setTitle(fairy?.capitalized, for: .normal); buttonList[19].setTitle(unknown?.capitalized, for: .normal); buttonList[20].setTitle(shadow?.capitalized, for: .normal)
    }
    
    
    //MARK: - crashlyticsErrorSending
    func crashlyticsErrorSending(){
        //Enviar email del usuario
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        //Enviar claves personalizadas
        Crashlytics.crashlytics().setCustomValue(email, forKey: "USER")
        //Enviar logs de errores
        Crashlytics.crashlytics().log("Error in PokemonListViewController")
    }
}


//MARK: - PokemonListViewDelegate methods
extension PokemonListViewController: PokemonListViewDelegate {
    
    
    //MARK: - Fetch favourites method
    func updateFavourites(favourites: [Favourites]) {
        self.favourites.removeAll()
        self.favourites = favourites
    }
    
    
    //MARK: - Updates filters
    func updateFiltersTableView(pokemons: PokemonFilterListData) {
        orderByButton.setTitle(NSLocalizedString("Order_by_Name", comment: ""), for: .normal)
        cleanSearchBar()
        self.pokemon.removeAll()
        self.filtered.removeAll()
        for pokemonType in pokemons.pokemon{
            guard let name = pokemonType.pokemon?.name else{return}
            pokemon.append(Results(name: name))
            filtered.append(Results(name: name))
        }
        self.tableView.reloadData()
    }
    

    //MARK: - Updates tableView after fetching pokemon list
    func updateTableView(pokemons: PokemonListData) {
        orderByButton.setTitle(NSLocalizedString("Order_by_Name", comment: ""), for: .normal)
        cleanSearchBar()
        if filtered.isEmpty && pokemon.isEmpty{
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.saveFilteredOrder = self.pokemon
            self.tableView.reloadData()
        }
        else{
            pokemon.removeAll()
            filtered.removeAll()
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.saveFilteredOrder = self.pokemon
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - TableView from cell method
    func updateTableView() {
        self.tableView.reloadData()
    }
}


//MARK: - UITableViewDelegate and UITableViewDataSource Methods
extension PokemonListViewController:UITableViewDelegate, UITableViewDataSource{
    
    
    //MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count; //Row count
        
    }
    
    
    //MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        pokemonInCell = filtered[indexPath.row]
        cell.updatePokemonInCell(pokemonToFetch: pokemonInCell!)
        
        return cell
    }
    
    
    //MARK: - didSelectRowAt
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
        guard let pokemonSelected = pokemonSelected, let nextPokemon = nextPokemon, let previousPokemon = previousPokemon else{return}
        presenter?.openPokemonDetail(pokemon: pokemonSelected, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
        
    }
    
    
    //MARK: - leadingSwipeActionsConfigurationForRowAt
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { //Only working when using breakpoint
        if user != nil{
            presenter?.fetchFavourites()
            var arrayOfFavouritesNames: [String] = []
            for favs in favourites{
                //doesn't update
                arrayOfFavouritesNames.append(favs.name!)
            }
            if arrayOfFavouritesNames.contains(self.filtered[indexPath.row].name!){
                alert.show(
                    title: NSLocalizedString("Pokemon_already_added_to_favourites", comment: ""),
                    info: "",
                    titleOk: "OK",
                    completionOk: nil
                )
                return nil
            }else{
                let action = UIContextualAction(style: .normal, title: NSLocalizedString("Add", comment: ""), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                    self.presenter?.addFavourite(pokemon: self.filtered[indexPath.row])
                    self.favourites.append(Favourites(name: self.filtered[indexPath.row].name!))
                    self.alert.show(
                        title: NSLocalizedString("Pokemon_added_to_favourites", comment: ""),
                        info: "",
                        titleOk: "OK",
                        completionOk: nil
                        
                    )
                    success(true)
                })
                action.backgroundColor = .init(red: 41/255, green: 130/255, blue: 251/255, alpha: 1)
                return UISwipeActionsConfiguration(actions: [action])
            }
        }else{
            alert.show(
                title: NSLocalizedString("Favourites", comment: ""),
                info: NSLocalizedString("You_will_not_be_able_to_add_any_pokemons_to_favourites_until_you_login_or_sign_up_Would_you_like_to_login_or_sign_up", comment: ""),
                titleOk: NSLocalizedString("Yes", comment: ""),
                titleCancel: NSLocalizedString("No", comment: ""),
                completionOk: {
                    self.presenter?.openLoginSignUpWindow()
                },
                completionCancel: nil
            )
            return nil
        }
    }
    
    
    //MARK: - editingStyleForRowAt
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

//MARK: - UISearchBarDelegate methods
extension PokemonListViewController:UISearchBarDelegate{
    
    
    //MARK: - textDidChange
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty {
            self.filtered = self.pokemon
            self.saveFilteredOrder = self.pokemon
        } else {
            self.filtered = self.pokemon.filter({ pokemon in
                guard let name = pokemon.name else { return false }
                return name.lowercased().contains(searchText.lowercased())
            })
            self.saveFilteredOrder = self.pokemon.filter({ pokemon in
                guard let name = pokemon.name else { return false }
                return name.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }

    
    //MARK: - keyboardWillShow
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            
        }
    }
    
    
    //MARK: - keyboardWillHide
    @objc private func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {//If it has value
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
}


//MARK: - OrderBy Buttons methods
extension PokemonListViewController{
    
    @objc func pressedOrderBy(_ sender: ZeroTextButton!) {
        if orderByButton.titleLabel?.text == NSLocalizedString("Order_by_Name", comment: ""){
            orderByButton.setTitle(NSLocalizedString("Order_by_Id", comment: ""), for: .normal)
            self.filtered = filtered.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.tableView.reloadData()
        }
        else{
            orderByButton.setTitle(NSLocalizedString("Order_by_Name", comment: ""), for: .normal)
            if searchBar.text?.isEmpty == true{
                self.filtered = self.pokemon
            }else{
                self.filtered = self.saveFilteredOrder
            }
            
            self.tableView.reloadData()
        }
        
    }
}


//MARK: - Filter Buttons methods
extension PokemonListViewController{
    
    @objc func pressedFilterButton(_ sender: ZeroContainedButton!){
        switch sender.titleLabel?.text?.lowercased(){
        case all:
            self.presenter?.fetchPokemonList()
        case normal:
            self.presenter?.fetchPokemonType(type: TypeName.normal)
        case fighting:
            self.presenter?.fetchPokemonType(type: TypeName.fighting)
        case flying:
            self.presenter?.fetchPokemonType(type: TypeName.flying)
        case poison:
            self.presenter?.fetchPokemonType(type: TypeName.poison)
        case ground:
            self.presenter?.fetchPokemonType(type: TypeName.ground)
        case rock:
            self.presenter?.fetchPokemonType(type: TypeName.rock)
        case bug:
            self.presenter?.fetchPokemonType(type: TypeName.bug)
        case ghost:
            self.presenter?.fetchPokemonType(type: TypeName.ghost)
        case steel:
            self.presenter?.fetchPokemonType(type: TypeName.steel)
        case fire:
            self.presenter?.fetchPokemonType(type: TypeName.fire)
        case water:
            self.presenter?.fetchPokemonType(type: TypeName.water)
        case grass:
            self.presenter?.fetchPokemonType(type: TypeName.grass)
        case electric:
            self.presenter?.fetchPokemonType(type: TypeName.electric)
        case psychic:
            self.presenter?.fetchPokemonType(type: TypeName.psychic)
        case ice:
            self.presenter?.fetchPokemonType(type: TypeName.ice)
        case dragon:
            self.presenter?.fetchPokemonType(type: TypeName.dragon)
        case dark:
            self.presenter?.fetchPokemonType(type: TypeName.dark)
        case fairy:
            self.presenter?.fetchPokemonType(type: TypeName.fairy)
        case unknown:
            self.presenter?.fetchPokemonType(type: TypeName.unknown)
        case shadow:
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
    func setPokemonTextColor(_ color: UIColor, _ button: ZeroContainedButton){
        button.setTitleColor(color, for: .normal)
    }
    func setFilterButtonsBackground(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ button: ZeroContainedButton){
        button.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    func paintButton(_ button: ZeroContainedButton){
        switch button.titleLabel?.text?.lowercased(){
        case "all":
            button.backgroundColor = .white//.init(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
            setPokemonTextColor(.black, button)
        case TypeName.normal:
            setFilterButtonsBackground(168, 168, 120, button)
            setPokemonTextColor(.white, button)
        case TypeName.fighting:
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
