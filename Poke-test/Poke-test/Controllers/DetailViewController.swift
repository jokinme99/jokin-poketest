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
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData) {
        DispatchQueue.main.async {
            self.labelPokemonName.text = pokemon.name.uppercased() // The selected one
            if let downloadURL = URL(string: pokemon.sprites.front_default){
                return  self.imagePokemon.af.setImage(withURL: downloadURL )
            }else {
                return
            }
            

           
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}
//MARK: - Data Manipulation Method
extension DetailViewController{
    func selectedPokemonInList(){
        if let namePokemon = selectedPokemon{
            pokemonManager.fetchPokemon(namePokemon: namePokemon)
        }else{
            return
        }
        
    }
}


