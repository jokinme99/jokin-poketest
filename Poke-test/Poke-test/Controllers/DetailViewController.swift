

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var labelPokemonName: UILabel!
    @IBOutlet weak var labelPokemonType: UILabel!
    @IBOutlet weak var labelPokemonType2: UILabel!
    var pokemonManager = PokemonManager()
    //var typePokemon: String?
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
            self.labelPokemonType.text = pokemon.types[0].type.name.uppercased()
            if pokemon.types.count >= 2{// If a pokemon has two or more types
                self.labelPokemonType2.text = pokemon.types[1].type.name.uppercased()
                self.paintType(label: self.labelPokemonType)
                self.paintType(label: self.labelPokemonType2)
            }else{//If a pokemon has one type
                self.paintType(label: self.labelPokemonType)
                self.labelPokemonType2.isHidden = true
            }
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
    func paintType(label: UILabel){
        switch label.text?.lowercased() {
            case TypeName.normal:
                setPokemonBackgroundColor(168, 168, 120, label)
                setPokemonTextColor(.white, label)
            case TypeName.fight:
                setPokemonBackgroundColor(192, 48, 40, label)
                setPokemonTextColor(.white, label)
            case TypeName.flying:
                setPokemonBackgroundColor(168, 144, 240, label)
                setPokemonTextColor(.white, label)
            case TypeName.poison:
                setPokemonBackgroundColor(160, 64, 160, label)
                setPokemonTextColor(.white, label)
            case TypeName.ground:
                setPokemonBackgroundColor(224, 192, 104, label)
                setPokemonTextColor(.black, label)
            case TypeName.rock:
                setPokemonBackgroundColor(184, 160, 56, label)
                setPokemonTextColor(.black, label)
            case TypeName.bug:
                setPokemonBackgroundColor(168, 184, 32, label)
                setPokemonTextColor(.white, label)
            case TypeName.ghost:
                setPokemonBackgroundColor(112, 88, 152, label)
                setPokemonTextColor(.white, label)
            case TypeName.steel:
                setPokemonBackgroundColor(184, 184, 208, label)
                setPokemonTextColor(.black, label)
            case TypeName.fire:
                setPokemonBackgroundColor(240, 128, 48, label)
                setPokemonTextColor(.black, label)
            case TypeName.water:
                setPokemonBackgroundColor(104, 144, 240, label)
                setPokemonTextColor(.white, label)
            case TypeName.grass:
                setPokemonBackgroundColor(120, 200, 80, label)
                setPokemonTextColor(.white, label)
            case TypeName.electric:
                setPokemonBackgroundColor(248, 208, 48, label)
                setPokemonTextColor(.black, label)
            case TypeName.psychic:
                setPokemonBackgroundColor(248, 88, 136, label)
                setPokemonTextColor(.white, label)
            case TypeName.ice:
                setPokemonBackgroundColor(152, 216, 216, label)
                setPokemonTextColor(.black, label)
                break
            case TypeName.dragon:
                setPokemonBackgroundColor(112, 56, 248, label)
                setPokemonTextColor(.white, label)
            case TypeName.dark:
                setPokemonBackgroundColor(112, 88, 72, label)
                setPokemonTextColor(.white, label)
            case TypeName.fairy:
                setPokemonBackgroundColor(238, 153, 172, label)
                setPokemonTextColor(.black, label)
            case TypeName.unknown:
                setPokemonBackgroundColor(0, 0, 0, label)
                setPokemonTextColor(.white, label)
            case TypeName.shadow:
                setPokemonBackgroundColor(124, 110, 187, label)
                setPokemonTextColor(.white, label)
            default:
                setPokemonBackgroundColor(216, 229, 234, label)
                setPokemonTextColor(.black, label)
    }
    }
    func setPokemonBackgroundColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ label: UILabel){
            label.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
            //labelPokemonType2.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
       }

    func setPokemonTextColor(_ color: UIColor, _ label: UILabel){
            label.textColor = color
            //labelPokemonType2.textColor = color
        
    }
}


