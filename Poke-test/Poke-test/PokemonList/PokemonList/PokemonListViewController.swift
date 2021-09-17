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
    var presenter: PokemonListPresenterDelegate?
    var cellPresenter: PokemonListCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDelegates()
        presenter?.fetchPokemonList()
        tableView.register(UINib(nibName: "PokemonCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        orderByButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }
}

extension PokemonListViewController: PokemonListViewDelegate {
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
        return filtered.count;
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonCell
        let pokemonInCell = filtered[indexPath.row]
        cell.updatePokemonInCell(pokemonToFetch: pokemonInCell)//Saves correctly
        //cell.checkIfFavouritePokemon(pokemonName: pokemonInCell.name!)//Doesn't work
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pokemonSelected = filtered[indexPath.row]
        presenter?.openPokemonDetail(with: pokemonSelected!)//It works
    }

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
