//
//  PokemonListViewController.swift
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

class PokemonListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderByButton: ZeroTextButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var orderBySearchView: UIView!
    @IBOutlet var buttonList: [ZeroContainedButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    var presenter: PokemonListPresenterDelegate?
    var pokemon: [Results] = []
    var filtered: [Results] = []
    var saveFilteredOrder: [Results] = []
    var pokemonSelected: Results?
    var cell: PokemonCell?
    var pokemonInCell: Results?
    var nextPokemon: Results?
    var previousPokemon: Results?
    var favourites: [Favourites] = []
    let user = Auth.auth().currentUser
    var alert = ZeroDialog()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
        loadStyle()
        presenter?.fetchPokemonList()
        presenter?.fetchFavourites()
        tableView.register(.customCell1, forCellReuseIdentifier: MenuConstants.customCell1Name)
        loadButtons()
        loadSearchBar()
        crashlyticsErrorSending()
    }
    override func viewWillAppear(_ animated: Bool) {
        for filter in filtered where filter.isInvalidated {
            filtered.removeAll()
            presenter?.fetchPokemonList()
            self.pokemon = filtered
            self.saveFilteredOrder = filtered
        }
    }
}

extension PokemonListViewController {

    func loadDelegates() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    func loadButtons() {
        orderByButton.addTarget(self, action: #selector(pressedOrderBy), for: .touchUpInside)
        for button in buttonList {
            button.addTarget(self, action: #selector(pressedFilterButton), for: .touchUpInside)
            paintButton(button)
        }
        orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
        loadFilterButtons()
    }

    func loadStyle() {
        tableView.rowHeight = 50.0
        orderBySearchView.layer.cornerRadius = 10
        searchBar.layer.cornerRadius = 5
        tableView.layer.cornerRadius = 5
        scrollView.layer.cornerRadius = 5
        for button in buttonList {
            button.layer.cornerRadius = 1
        }
        orderByButton.style = .normal
        searchBar.searchBarStyle = .minimal
        orderByButton.apply(ZeroTheme.Button.normal)
    }

    func loadSearchBar() {
        self.searchBar.addDoneButtonOnKeyboard()
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        searchBar.placeholder = MenuConstants.searchBarPlaceholder
    }

    func loadFilterButtons() {
        buttonList[0].setTitle(TypeName.all.localized.capitalized, for: .normal)
        buttonList[1].setTitle(TypeName.normal.localized.capitalized, for: .normal)
        buttonList[2].setTitle(TypeName.fighting.localized.capitalized, for: .normal)
        buttonList[3].setTitle(TypeName.flying.localized.capitalized, for: .normal)
        buttonList[4].setTitle(TypeName.poison.localized.capitalized, for: .normal)
        buttonList[5].setTitle(TypeName.ground.localized.capitalized, for: .normal)
        buttonList[6].setTitle(TypeName.rock.localized.capitalized, for: .normal)
        buttonList[7].setTitle(TypeName.bug.localized.capitalized, for: .normal)
        buttonList[8].setTitle(TypeName.ghost.localized.capitalized, for: .normal)
        buttonList[9].setTitle(TypeName.steel.localized.capitalized, for: .normal)
        buttonList[10].setTitle(TypeName.fire.localized.capitalized, for: .normal)
        buttonList[11].setTitle(TypeName.water.localized.capitalized, for: .normal)
        buttonList[12].setTitle(TypeName.grass.localized.capitalized, for: .normal)
        buttonList[13].setTitle(TypeName.electric.localized.capitalized, for: .normal)
        buttonList[14].setTitle(TypeName.psychic.localized.capitalized, for: .normal)
        buttonList[15].setTitle(TypeName.ice.localized.capitalized, for: .normal)
        buttonList[16].setTitle(TypeName.dragon.localized.capitalized, for: .normal)
        buttonList[17].setTitle(TypeName.dark.localized.capitalized, for: .normal)
        buttonList[18].setTitle(TypeName.fairy.localized.capitalized, for: .normal)
        buttonList[19].setTitle(TypeName.unknown.localized.capitalized, for: .normal)
        buttonList[20].setTitle(TypeName.shadow.localized.capitalized, for: .normal)
    }

    func crashlyticsErrorSending() {
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: CrashlyticsConstants.key)
        Crashlytics.crashlytics().log(CrashlyticsConstants.List.log)
    }
}

extension PokemonListViewController: PokemonListViewDelegate {

    func updateFavourites(favourites: [Favourites]) {
        self.favourites.removeAll()
        self.favourites = favourites
    }

    func updateFiltersTableView(pokemons: PokemonFilterListData) {
        orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
        cleanSearchBar()
        self.pokemon.removeAll()
        self.filtered.removeAll()
        for pokemonType in pokemons.pokemon {
            guard let name = pokemonType.pokemon?.name else {return}
            pokemon.append(Results(name: name))
            filtered.append(Results(name: name))
        }
        self.tableView.reloadData()
    }

    func updateTableView(pokemons: PokemonListData) {
        orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
        cleanSearchBar()
        if filtered.isEmpty && pokemon.isEmpty {
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.saveFilteredOrder = self.pokemon
            self.tableView.reloadData()
        } else {
            pokemon.removeAll()
            filtered.removeAll()
            self.pokemon = Array(pokemons.results)
            self.filtered = self.pokemon
            self.saveFilteredOrder = self.pokemon
            self.tableView.reloadData()
        }
    }

    func updateTableView() {
        self.tableView.reloadData()
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(
            withIdentifier: MenuConstants.customCell1Name, for: indexPath) as? PokemonCell
        pokemonInCell = filtered[indexPath.row]
        if let cell = cell {
            cell.updatePokemonInCell(pokemonToFetch: pokemonInCell!)
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let previousRow = row - 1
        let nextRow = row + 1
        if filtered.count == 1 {
            pokemonSelected = filtered[row]
            nextPokemon = Results()
            previousPokemon = Results()
        } else {
            if row == 0 {
                pokemonSelected = filtered[row]
                nextPokemon = filtered[nextRow]
                previousPokemon = filtered.last
            } else if row == filtered.count - 1 {
                pokemonSelected = filtered[row]
                previousPokemon = filtered[previousRow]
                nextPokemon = filtered.first
            } else {
                nextPokemon = filtered[nextRow]
                pokemonSelected = filtered[row]
                previousPokemon = filtered[previousRow]
            }
        }
        guard let pokemonSelected = pokemonSelected, let nextPokemon = nextPokemon,
              let previousPokemon = previousPokemon else {return}
        presenter?.openPokemonDetail(
            pokemon: pokemonSelected, nextPokemon: nextPokemon, previousPokemon: previousPokemon, filtered: filtered)
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if user != nil {
            presenter?.fetchFavourites()
            var arrayOfFavouritesNames: [String] = []
            for favs in favourites {
                arrayOfFavouritesNames.append((favs.name?.lowercased())!)
            }
            if arrayOfFavouritesNames.contains(self.filtered[indexPath.row].name!) {
                alert.show(
                    title: MenuConstants.alreadyInFavourites,
                    info: "",
                    titleOk: MenuConstants.okTitle,
                    completionOk: nil
                )
                return nil
            } else {
                let action = UIContextualAction(style: .normal, title: MenuConstants.addButtonTitle,
                    handler: { (_, _, success: (Bool) -> Void) in
                    self.presenter?.addFavourite(pokemon: self.filtered[indexPath.row])
                    self.favourites.append(Favourites(name: self.filtered[indexPath.row].name!))
                    self.alert.show(
                        title: MenuConstants.addedToFavourites,
                        info: "",
                        titleOk: MenuConstants.okTitle,
                        completionOk: nil
                    )
                    success(true)
                })
                action.backgroundColor = .init(red: 41/255, green: 130/255, blue: 251/255, alpha: 1)
                return UISwipeActionsConfiguration(actions: [action])
            }
        } else {
            alert.show(
                title: MenuConstants.favsListBar,
                info: MenuConstants.notAbleToAddFavourites,
                titleOk: MenuConstants.yesTitle,
                titleCancel: MenuConstants.noTitle,
                completionOk: {
                    self.presenter?.openLoginSignUpWindow()
                },
                completionCancel: nil
            )
            return nil
        }
    }

    func tableView(
        _ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

extension PokemonListViewController: UISearchBarDelegate {

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

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
                               as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
             as? NSValue)?.cgRectValue) != nil {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
}

extension PokemonListViewController {
    @objc func pressedOrderBy(_ sender: ZeroTextButton!) {
        if orderByButton.titleLabel?.text == MenuConstants.orderByNameButtonTitle {
            orderByButton.setTitle(MenuConstants.orderByIdButtonTitle, for: .normal)
            self.filtered = filtered.sorted(by: {$0.name ?? "" < $1.name ?? ""})
            self.tableView.reloadData()
        } else {
            orderByButton.setTitle(MenuConstants.orderByNameButtonTitle, for: .normal)
            guard let searchBarText = searchBar.text else {return}
            if searchBarText.isEmpty {
                self.filtered = self.pokemon
            } else {
                self.filtered = self.saveFilteredOrder
            }
            self.tableView.reloadData()
        }
    }
}

extension PokemonListViewController {
    @objc func pressedFilterButton(_ sender: ZeroContainedButton!) {
        switch sender.titleLabel?.text?.lowercased() {
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
        case .some:
            print("Error: .some(_)")
        }
    }
    func cleanSearchBar() {
        if searchBar.text?.isEmpty == false {
            searchBar.text?.removeAll()
        }
    }
}

extension PokemonListViewController {
    func setPokemonTextColor(_ color: UIColor, _ button: ZeroContainedButton) {
        button.setTitleColor(color, for: .normal)
    }
    func setFilterButtonsBackground(
        _ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ button: ZeroContainedButton) {
        button.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    func paintButton(_ button: ZeroContainedButton) {
        switch button.titleLabel?.text?.lowercased() {
        case TypeName.all.rawValue:
            button.backgroundColor = .white
            // .init(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
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
        case .some:
            print("Error in some(_)")
        }
    }
}
