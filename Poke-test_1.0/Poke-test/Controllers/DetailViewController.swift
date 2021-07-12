//
//  DetailViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/7/21.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var labelPokemonName: UILabel!
    var pokemonManager = PokemonManager()
    
    var selectedPokemon : String? {//Has selected a name
        didSet{
            selectedPokemonInList()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonManager.delegate = self
        selectedPokemonInList()
    }
    
    
}
//MARK: - PokemonDelegate Methods
extension DetailViewController: PokemonManagerDelegate{
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonModel) {
        DispatchQueue.main.async {
            self.labelPokemonName.text = pokemon.namePokemon.uppercased() // The selected one
            let downloadURL = URL(string: pokemon.imagePokemon)!
            self.imagePokemon.af.setImage(withURL: downloadURL )
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - Data Manipulation Method
extension DetailViewController{
    func selectedPokemonInList(){
        pokemonManager.fetchPokemon(namePokemon: selectedPokemon!)//enters in the api the pokemon selected in the WelcomeViewController
    }
}


