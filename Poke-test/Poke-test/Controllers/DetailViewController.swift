

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
        
            if pokemon.types.count > 1{
                self.labelPokemonType.text = pokemon.types[0].type.name.uppercased()
                self.labelPokemonType2.text = pokemon.types[1].type.name.uppercased()
            }else{
                self.labelPokemonType.text = pokemon.types[0].type.name.uppercased()
                self.labelPokemonType2.isHidden = true
            }
            self.paintType(type: self.labelPokemonType.text!)
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
    func paintType(type: String){
        switch type {
            case TypeName.normal:
                setPokemonBackgroundColor(168, 168, 120)
                setPokemonTextColor(.white)
            case TypeName.fight:
                setPokemonBackgroundColor(192, 48, 40)
                setPokemonTextColor(.white)
            case TypeName.flying:
                setPokemonBackgroundColor(168, 144, 240)
                setPokemonTextColor(.white)
            case TypeName.poison:
                setPokemonBackgroundColor(160, 64, 160)
                setPokemonTextColor(.white)
            case TypeName.ground:
                setPokemonBackgroundColor(224, 192, 104)
                setPokemonTextColor(.black)
            case TypeName.rock:
                setPokemonBackgroundColor(184, 160, 56)
                setPokemonTextColor(.black)
            case TypeName.bug:
                setPokemonBackgroundColor(168, 184, 32)
                setPokemonTextColor(.white)
            case TypeName.ghost:
                setPokemonBackgroundColor(112, 88, 152)
                setPokemonTextColor(.white)
            case TypeName.steel:
                setPokemonBackgroundColor(184, 184, 208)
                setPokemonTextColor(.black)
            case TypeName.fire:
                setPokemonBackgroundColor(240, 128, 48)
                setPokemonTextColor(.black)
            case TypeName.water:
                setPokemonBackgroundColor(104, 144, 240)
                setPokemonTextColor(.white)
            case TypeName.grass:
                setPokemonBackgroundColor(120, 200, 80)
                setPokemonTextColor(.white)
            case TypeName.electric:
                setPokemonBackgroundColor(248, 208, 48)
                setPokemonTextColor(.black)
            case TypeName.psychic:
                setPokemonBackgroundColor(248, 88, 136)
                setPokemonTextColor(.white)
            case TypeName.ice:
                setPokemonBackgroundColor(152, 216, 216)
                setPokemonTextColor(.black)
            case TypeName.dragon:
                setPokemonBackgroundColor(112, 56, 248)
                setPokemonTextColor(.white)
            case TypeName.dark:
                setPokemonBackgroundColor(112, 88, 72)
                setPokemonTextColor(.white)
            case TypeName.fairy:
                setPokemonBackgroundColor(238, 153, 172)
                setPokemonTextColor(.black)
            case TypeName.unknown:
                setPokemonBackgroundColor(0, 0, 0)
                setPokemonTextColor(.white)
            case TypeName.shadow:
                setPokemonBackgroundColor(124, 110, 187)
                setPokemonTextColor(.white)
            default:
                labelPokemonType.backgroundColor = #colorLiteral(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
                setPokemonTextColor(.black)
    }
    }
    func setPokemonBackgroundColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat){
        if labelPokemonType2.isHidden == false{
            labelPokemonType.backgroundColor = .init(red: red, green: green, blue: blue, alpha: 33)
            labelPokemonType2.backgroundColor = .init(red: red, green: green, blue: blue, alpha: 33)
        }else{
            labelPokemonType.backgroundColor = .init(red: red, green: green, blue: blue, alpha: 33)
        }

    }
    func setPokemonTextColor(_ color: UIColor){
        if labelPokemonType2.isHidden == false{
            labelPokemonType.textColor = color
            labelPokemonType2.textColor = color
        }else{
            labelPokemonType.textColor = color
        }
    }
}


