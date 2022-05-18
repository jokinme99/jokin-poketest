//
//  PokemonCollectionViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import UIKit
import NotificationCenter
import RealmSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCrashlytics
import Zero

class PokemonCollectionViewController: UIViewController {
    
    @IBOutlet weak var orderBySearchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var orderByButton: ZeroTextButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var buttonList: [ZeroContainedButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var presenter: PokemonCollectionPresenterDelegate?
    var pokemon: [Results] = []
    var filtered: [Results] = []
    var saveFilteredOrder: [Results] = []
    var cell = CollectionCell()
    var pokemonInCell: Results?
    var pokemonSelected: Results?
    var nextPokemon: Results?
    var previousPokemon: Results?
    var favourites: [Favourites] = []
    let user = Auth.auth().currentUser
    let inset: CGFloat = 10
    let minimumLineSpacing: CGFloat = 10
    let minimumInteritemSpacing: CGFloat = 10
    let cellsPerRow = 3

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCollectionView()
        loadDelegates()
        presenter?.fetchPokemonList()
        loadButtons()
        loadSearchBar()
        loadStyle()
        crashlyticsErrorSending()
    }
   
}

extension PokemonCollectionViewController{

    func loadDelegates(){
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func loadButtons(){
        orderByButton.addTarget(self, action: #selector(pressedOrderBy), for: .touchUpInside)
        for button in buttonList{
            button.addTarget(self, action: #selector(pressedFilterButton), for: .touchUpInside)
            paintButton(button)
        }
        orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
        loadFilterButtons()
    }
  
    func loadSearchBar(){
        self.searchBar.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        searchBar.placeholder = MenuConstants.searchBarPlaceholder
    }

    func loadStyle(){
        orderBySearchView.layer.cornerRadius = 10
        searchBar.layer.cornerRadius = 5
        collectionView.layer.cornerRadius = 5
        scrollView.layer.cornerRadius = 5
        for b in buttonList{
            b.layer.cornerRadius = 1
        }
        orderByButton.style = .normal
        searchBar.searchBarStyle = .minimal
        orderByButton.apply(ZeroTheme.Button.normal)
    }

    func loadFilterButtons(){
        buttonList[0].setTitle(TypeName.all.localized.capitalized, for: .normal); buttonList[1].setTitle(TypeName.normal.localized.capitalized, for: .normal); buttonList[2].setTitle(TypeName.fighting.localized.capitalized, for: .normal)
        buttonList[3].setTitle(TypeName.flying.localized.capitalized, for: .normal); buttonList[4].setTitle(TypeName.poison.localized.capitalized, for: .normal); buttonList[5].setTitle(TypeName.ground.localized.capitalized, for: .normal)
        buttonList[6].setTitle(TypeName.rock.localized.capitalized, for: .normal); buttonList[07].setTitle(TypeName.bug.localized.capitalized, for: .normal); buttonList[8].setTitle(TypeName.ghost.localized.capitalized, for: .normal)
        buttonList[9].setTitle(TypeName.steel.localized.capitalized, for: .normal); buttonList[10].setTitle(TypeName.fire.localized.capitalized, for: .normal); buttonList[11].setTitle(TypeName.water.localized.capitalized, for: .normal)
        buttonList[12].setTitle(TypeName.grass.localized.capitalized, for: .normal); buttonList[13].setTitle(TypeName.electric.localized.capitalized, for: .normal); buttonList[14].setTitle(TypeName.psychic.localized.capitalized, for: .normal)
        buttonList[15].setTitle(TypeName.ice.localized.capitalized, for: .normal); buttonList[16].setTitle(TypeName.dragon.localized.capitalized, for: .normal); buttonList[17].setTitle(TypeName.dark.localized.capitalized, for: .normal)
        buttonList[18].setTitle(TypeName.fairy.localized.capitalized, for: .normal); buttonList[19].setTitle(TypeName.unknown.localized.capitalized, for: .normal); buttonList[20].setTitle(TypeName.shadow.localized.capitalized, for: .normal)
    }

    func crashlyticsErrorSending(){
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: CrashlyticsConstants.key)
        Crashlytics.crashlytics().log(CrashlyticsConstants.Collection.log)
    }
    
    func loadCollectionView(){
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView.register(.customCell2, forCellWithReuseIdentifier: MenuConstants.customCell2Name)
    }
}

extension PokemonCollectionViewController: PokemonCollectionViewDelegate {
    
    func updateListCollectionView(pokemons: PokemonListData) {
        orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
        cleanSearchBar()
        if filtered.isEmpty && pokemon.isEmpty{
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.saveFilteredOrder = self.pokemon
            self.collectionView.reloadData()
        }
        else{
            pokemon.removeAll()
            filtered.removeAll()
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.saveFilteredOrder = self.pokemon
            self.collectionView.reloadData()
        }
    }
    
    func updateFavouritesCollectionView(favourites: [Favourites]) {
        self.favourites = favourites
    }

    func updateFiltersCollectionView(pokemons: PokemonFilterListData) {
        orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
        cleanSearchBar()
        self.pokemon.removeAll()
        self.filtered.removeAll()
        for pokemonType in pokemons.pokemon{
            guard let name = pokemonType.pokemon?.name else{return}
            pokemon.append(Results(name: name))
            filtered.append(Results(name: name))
        }
        self.collectionView.reloadData()
    }
    
    func updateCollectionView() {
        self.collectionView.reloadData()
    }
}

extension PokemonCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuConstants.customCell2Name, for: indexPath) as! CollectionCell
        pokemonInCell = filtered[indexPath.row]
        cell.updatePokemonCollection(pokemonToUpdate: pokemonInCell ?? Results())
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtered.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return minimumLineSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInteritemSpacing
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           collectionView?.collectionViewLayout.invalidateLayout()
           super.viewWillTransition(to: size, with: coordinator)
       }
}

extension PokemonCollectionViewController: UISearchBarDelegate{

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
        self.collectionView.reloadData()
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {//If it has value
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension PokemonCollectionViewController{
    
    @objc func pressedOrderBy(_ sender: ZeroTextButton!) {
        if orderByButton.titleLabel?.text == MenuConstants.orderByNameButtonTitle{
            orderByButton.setTitle(MenuConstants.orderByIdButtonTitle, for: .normal)
            self.filtered = filtered.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.collectionView.reloadData()
        }
        else{
            orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
            if searchBar.text?.isEmpty == true{
                self.filtered = self.pokemon
            }else{
                self.filtered = self.saveFilteredOrder
            }
            self.collectionView.reloadData()
        }
    }
}

extension PokemonCollectionViewController{
    
    @objc func pressedFilterButton(_ sender: ZeroContainedButton!){
        switch sender.titleLabel?.text?.lowercased(){
        case TypeName.all.localized:
            self.presenter?.fetchPokemonList()
        case TypeName.normal.localized:
            self.presenter?.fetchPokemonType(type: TypeName.normal.rawValue)
        case TypeName.fighting.localized:
            self.presenter?.fetchPokemonType(type: TypeName.fighting.rawValue)
        case TypeName.flying.localized:
            self.presenter?.fetchPokemonType(type: TypeName.flying.rawValue)
        case TypeName.poison.localized:
            self.presenter?.fetchPokemonType(type: TypeName.poison.rawValue)
        case TypeName.ground.localized:
            self.presenter?.fetchPokemonType(type: TypeName.ground.rawValue)
        case TypeName.rock.localized:
            self.presenter?.fetchPokemonType(type: TypeName.rock.rawValue)
        case TypeName.bug.localized:
            self.presenter?.fetchPokemonType(type: TypeName.bug.rawValue)
        case TypeName.ghost.localized:
            self.presenter?.fetchPokemonType(type: TypeName.ghost.rawValue)
        case TypeName.steel.localized:
            self.presenter?.fetchPokemonType(type: TypeName.steel.rawValue)
        case TypeName.fire.localized:
            self.presenter?.fetchPokemonType(type: TypeName.fire.rawValue)
        case TypeName.water.localized:
            self.presenter?.fetchPokemonType(type: TypeName.water.rawValue)
        case TypeName.grass.localized:
            self.presenter?.fetchPokemonType(type: TypeName.grass.rawValue)
        case TypeName.electric.localized:
            self.presenter?.fetchPokemonType(type: TypeName.electric.rawValue)
        case TypeName.psychic.localized:
            self.presenter?.fetchPokemonType(type: TypeName.psychic.rawValue)
        case TypeName.ice.localized:
            self.presenter?.fetchPokemonType(type: TypeName.ice.rawValue)
        case TypeName.dragon.localized:
            self.presenter?.fetchPokemonType(type: TypeName.dragon.rawValue)
        case TypeName.dark.localized:
            self.presenter?.fetchPokemonType(type: TypeName.dark.rawValue)
        case TypeName.fairy.localized:
            self.presenter?.fetchPokemonType(type: TypeName.fairy.rawValue)
        case TypeName.unknown.localized:
            self.presenter?.fetchPokemonType(type: TypeName.unknown.rawValue)
        case TypeName.shadow.localized:
            self.presenter?.fetchPokemonType(type: TypeName.shadow.rawValue)
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

extension PokemonCollectionViewController{
    
    func setPokemonTextColor(_ color: UIColor, _ button: ZeroContainedButton){
        button.setTitleColor(color, for: .normal)
    }
    
    func setFilterButtonsBackground(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ button: ZeroContainedButton){
        button.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    func paintButton(_ button: ZeroContainedButton){
        switch button.titleLabel?.text?.lowercased(){
        case TypeName.all.rawValue:
            button.backgroundColor = .white //.init(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
            setPokemonTextColor(.black, button)
        case TypeName.normal.rawValue:
            setFilterButtonsBackground(168, 168, 120, button)
            setPokemonTextColor(.white, button)
        case TypeName.fighting.rawValue:
            setFilterButtonsBackground(192, 48, 40, button)
            setPokemonTextColor(.white, button)
        case TypeName.flying.rawValue:
            setFilterButtonsBackground(168, 144, 240, button)
            setPokemonTextColor(.white, button)
        case TypeName.poison.rawValue:
            setFilterButtonsBackground(160, 64, 160, button)
            setPokemonTextColor(.white, button)
        case TypeName.ground.rawValue:
            setFilterButtonsBackground(224, 192, 104, button)
            setPokemonTextColor(.black, button)
        case TypeName.rock.rawValue:
            setFilterButtonsBackground(184, 160, 56, button)
            setPokemonTextColor(.black, button)
        case TypeName.bug.rawValue:
            setFilterButtonsBackground(168, 184, 32, button)
            setPokemonTextColor(.white, button)
        case TypeName.ghost.rawValue:
            setFilterButtonsBackground(112, 88, 152, button)
            setPokemonTextColor(.white, button)
        case TypeName.steel.rawValue:
            setFilterButtonsBackground(184, 184, 208, button)
            setPokemonTextColor(.black, button)
        case TypeName.fire.rawValue:
            setFilterButtonsBackground(240, 128, 48, button)
            setPokemonTextColor(.black, button)
        case TypeName.water.rawValue:
            setFilterButtonsBackground(104, 144, 240, button)
            setPokemonTextColor(.white, button)
        case TypeName.grass.rawValue:
            setFilterButtonsBackground(120, 200, 80, button)
            setPokemonTextColor(.white, button)
        case TypeName.electric.rawValue:
            setFilterButtonsBackground(248, 208, 48, button)
            setPokemonTextColor(.black, button)
        case TypeName.psychic.rawValue:
            setFilterButtonsBackground(248, 88, 136, button)
            setPokemonTextColor(.white, button)
        case TypeName.ice.rawValue:
            setFilterButtonsBackground(152, 216, 216, button)
            setPokemonTextColor(.black, button)
        case TypeName.dragon.rawValue:
            setFilterButtonsBackground(112, 56, 248, button)
            setPokemonTextColor(.white, button)
        case TypeName.dark.rawValue:
            setFilterButtonsBackground(112, 88, 72, button)
            setPokemonTextColor(.white, button)
        case TypeName.fairy.rawValue:
            setFilterButtonsBackground(238, 153, 172, button)
            setPokemonTextColor(.black, button)
        case TypeName.unknown.rawValue:
            setFilterButtonsBackground(0, 0, 0, button)
            setPokemonTextColor(.white, button)
        case TypeName.shadow.rawValue:
            setFilterButtonsBackground(124, 110, 187, button)
            setPokemonTextColor(.white, button)
        case .none:
            print("There aren't any buttons")
        case .some(_):
            print("Error in some(_)")
        }
    }
}
