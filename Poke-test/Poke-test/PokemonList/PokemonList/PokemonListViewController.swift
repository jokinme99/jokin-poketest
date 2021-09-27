//
//  PokemonListViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit

class PokemonListViewController: UIViewController { //SearchBar must be instead of searchController!!
    
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
    override func viewWillAppear(_ animated: Bool) { //When adding/deleting a pokemon the favourites list & the tableView have to load again
        presenter?.fetchFavourites()
        //self.tableView.reloadData()
    }
}

extension PokemonListViewController: PokemonListViewDelegate {
    func updateFavouritesFetchInCell(favourites: [Results]) {
        self.favouritesList = favourites
        
    }
    
    func updateDetailsFetchInCell(pokemonToPaint: PokemonData) { //2nd step
        //Solo pinta el ultimo pokemon
        //Al hacer scroll se pintan bien
        //Por cada vez que se fetchee se debe pintar la celda
        self.cell.paintCell(pokemonToPaint: pokemonToPaint)
       //Si contiene el valor del nombre del pokemon a pintar pinta la celda
        
    }
    
    func updateTableViewFavourites() {
        self.tableView.reloadData()
    }
    func updateTableView(pokemons: PokemonListData) {
        self.pokemon = Array(pokemons.results)
        self.filtered = self.pokemon
        self.savefilteredOrder = self.pokemon
        self.tableView.reloadData()
    }
}

//MARK: - TableView Methods
extension PokemonListViewController:UITableViewDelegate, UITableViewDataSource{ // Methods in charge of the UITableViewDelegate methods and the UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count; //Row count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        pokemonInCell = filtered[indexPath.row]//It works!
        cell.favouritesList = favouritesList
        cell.updatePokemonInCell(pokemonToFetch: pokemonInCell!)//OK!!!
        presenter?.fetchPokemonDetails(pokemon: pokemonInCell!)//FIX
        print("Pokemon in row: \(pokemonInCell?.name ?? "")")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokemonSelected = filtered[indexPath.row]
        presenter?.openPokemonDetail(with: pokemonSelected!)//It works
    }
    
}
//MARK: - FetchPokemonDetails method definition
extension PokemonListViewController{
    //The first row calls this method-> This fetchs the introduced pokemon and returns the result of the fetching in a method called didFetchPokemonDetails(In the interactor)->This method returns the value of the func didFetchPokemonDetails in to another func called updateDetailsFetchInCell(In the presenter)->This method takes the value received and sends it to the cell with a func called paintCell(In the view)-> This method comes up with the data (PokemonData defined in the Models: The pokemons's types, name and id) received of the before mentioned methods and what it does is the next: Sets introduced pokemon's Id and depending of the first(mayor) type paints the cell of one colour.
}
//MARK: - SearchBar Delegate methods
extension PokemonListViewController:UISearchBarDelegate{ // Method in charge of updating filteredData based on the text in the Search Box
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
//MARK: - OrderBy Buttons methods
extension PokemonListViewController{ // Methods in charge of the orderBy buttons
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
extension PokemonListViewController{ //Method in charge of the list of needed delegates
    func loadDelegates(){
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
}
