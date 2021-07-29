
import UIKit

class PokemonCell: UITableViewCell {
    
    @IBOutlet weak var pokemonBubble: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        pokemonNameLabel.layer.cornerRadius = pokemonNameLabel.frame.size.height/3


    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

//MARK: - Update methods
extension PokemonCell{
    func updatePokemonName(pokemonName: String){
        pokemonNameLabel.text = pokemonName
    }
    
    func updatePokemonType(pokemonType: String){//If pokemonList.result[?].contains(pokemonData.name){ pokemonType = pokemonData.types[0].type.name
        //Selected pokemonName -> Check what type is it and then set a color
        switch pokemonType{
        case "normal":
            pokemonBubble.backgroundColor = setPokemonColor(168, 168, 120)
        case "fight":
            pokemonBubble.backgroundColor = setPokemonColor(192, 48, 40)
        case "flying":
            pokemonBubble.backgroundColor = setPokemonColor(168, 144, 240)
        case "poison":
            pokemonBubble.backgroundColor = setPokemonColor(160, 64, 160)
        case "ground":
            pokemonBubble.backgroundColor = setPokemonColor(224, 192, 104)
        case "rock":
            pokemonBubble.backgroundColor = setPokemonColor(184, 160, 56)
        case "bug":
            pokemonBubble.backgroundColor = setPokemonColor(168, 184, 32)
        case "ghost":
            pokemonBubble.backgroundColor = setPokemonColor(112, 88, 152)
        case "steel":
            pokemonBubble.backgroundColor = setPokemonColor(184, 184, 208)
        case "fire":
            pokemonBubble.backgroundColor = setPokemonColor(240, 128, 48)
        case "water":
            pokemonBubble.backgroundColor = setPokemonColor(104, 144, 240)
        case "grass":
            pokemonBubble.backgroundColor = setPokemonColor(120, 200, 80)
        case "electric":
            pokemonBubble.backgroundColor = setPokemonColor(248, 208, 48)
        case "psychic":
            pokemonBubble.backgroundColor = setPokemonColor(248, 88, 136)
        case "ice":
            pokemonBubble.backgroundColor = setPokemonColor(152, 216, 216)
        case "dragon":
            pokemonBubble.backgroundColor = setPokemonColor(112, 56, 248)
        case "dark":
            pokemonBubble.backgroundColor = setPokemonColor(112, 88, 72)
        case "fairy":
            pokemonBubble.backgroundColor = setPokemonColor(238, 153, 172)
        case "unknown":
            pokemonBubble.backgroundColor = setPokemonColor(255, 255, 255)
        case "shadow":
            pokemonBubble.backgroundColor = setPokemonColor(124, 110, 187)
        default:
            pokemonBubble.backgroundColor = #colorLiteral(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
        }
    }
    func setPokemonColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat)->UIColor{
        return .init(red: red, green: green, blue: blue, alpha: 33)
    }
}
