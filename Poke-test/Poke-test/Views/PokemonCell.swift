//
//  PokemonCell.swift
//  Poke-test
//
//  Created by Jokin Egia on 28/7/21.
//

import UIKit

class PokemonCell: UITableViewCell {

    
    @IBOutlet weak var pokemonBubble: UIView!
    @IBOutlet weak var pokemonNameLabelCell: UILabel!
    @IBOutlet weak var pokemonTypeViewCell: UIView!//If it's grass type the letter should be green etc.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updatePokemonName(pokemonName: String){
        pokemonNameLabelCell.text = pokemonName
    }
    //MARK: - FINISH
    func updatePokemonType(pokemonName: String){//If it's bulbasaur should be green
        //Selected pokemonName -> Check what type is it and then set a color
        switch pokemonName{
        case "normal":
            pokemonTypeViewCell.backgroundColor = .brown
        case "fight":
            pokemonTypeViewCell.backgroundColor = .systemRed
        default:
            pokemonTypeViewCell.backgroundColor = #colorLiteral(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
        }
        
    }
    
    
}
