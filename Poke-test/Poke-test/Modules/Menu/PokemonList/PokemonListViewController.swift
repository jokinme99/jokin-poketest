
import UIKit
import NotificationCenter
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase


class PokemonListViewController: UIViewController {//PIN iPhone: 281106
    
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
    var presenter: PokemonListPresenterDelegate?
    var pokemonInCell: Results?
    var nextPokemon: Results?
    var previousPokemon: Results?
    var detailsPresenter: PokemonDetailsPresenter?
    var favourites: [Favourites] = []
    let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        super.viewDidLoad()
        loadDelegates()
        presenter?.fetchPokemonList()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        loadButtons()
        loadSearchBar()
        tableView.rowHeight = 50.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for filter in filtered {
            if filter.isInvalidated{
                filtered.removeAll()
                presenter?.fetchPokemonList()
                self.pokemon = filtered
                self.savefilteredOrder = filtered
            }
        }
    }
    
}
//MARK: - ViewDidLoad Methods
extension PokemonListViewController{
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
extension PokemonListViewController: PokemonListViewDelegate {
    //MARK: - Fetch favourites method
    func updateFavourites(favourites: [Favourites]) {
        self.favourites = favourites
    }
    
    //MARK: - Add favourite method
//    func addFavourite(pokemon: Results) {//Metodo para pintar
//        //presenter?.addFavourite(pokemon: pokemon)
//        presenter?.fetchFavourites()
//        self.tableView.reloadData()
//    }
    
    //MARK: - Updates filters
    func updateFiltersTableView(pokemons: PokemonFilterListData) {
        self.pokemon.removeAll()
        self.filtered.removeAll()
        for pokemonType in pokemons.pokemon{
            pokemon.append(Results(name: pokemonType.pokemon?.name! ?? "default"))
            filtered.append(Results(name: pokemonType.pokemon?.name! ?? "default"))
        }
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
    //MARK: - TableView from cell method
    func updateTableView() {
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
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? { //Only working with not logged
        if user != nil{
            presenter?.fetchFavourites()
            var arrayOfFavouritesNames: [String] = []
            for favs in favourites{
                arrayOfFavouritesNames.append(favs.name!)
            }
            if arrayOfFavouritesNames.contains(filtered[indexPath.row].name!){
                let alert = UIAlertController(title: "Pokemon already added to favourites", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return nil
            }else{
                let action = UIContextualAction(style: .destructive, title: nil) { action, view, completion in
                    self.presenter?.addFavourite(pokemon: self.filtered[indexPath.row])
                    completion(true)//Si se hace breakpoint funciona
                    }
                action.backgroundColor = .blue
                action.title = "Add"
                return UISwipeActionsConfiguration(actions: [action])
            }
        }else{
            return nil
        }
       
    
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
        /* let goUp: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowUp"), style: .done, target: self, action: #selector(self.goUpButtonAction))
         let goDown: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "arrowDown"), style: .done, target: self, action: #selector(self.goDownButtonAction)) */
        
        let items = [ /* goUp, goDown, */ flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    /*
     @objc func goDownButtonAction(){
     
     }
     @objc func goUpButtonAction(){
     
     } */
    
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
