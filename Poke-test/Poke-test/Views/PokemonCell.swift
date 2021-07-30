
import UIKit

class PokemonCell: UITableViewCell {
    
    @IBOutlet weak var pokemonBubble: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    var selectedPokemonList: [Results] = []//All Pokemons List
    var pokemonsListFromPokemonData: [PokemonData] = []//In the name insert a result and get the types[0].type.name)
    var pokemonManager = PokemonManager()
    override func awakeFromNib() {
        super.awakeFromNib()
        pokemonManager.delegate = self
        selectPokemons()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
//MARK: - PokemonManagerDelegate methods
extension PokemonCell: PokemonManagerDelegate{
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData) {
        self.pokemonsListFromPokemonData.append(pokemon)//Save the pokemons
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
//MARK: - Update methods
extension PokemonCell{
    func selectPokemons(){
        for pokemon in selectedPokemonList{
            pokemonManager.fetchPokemon(namePokemon: pokemon.name!)
        }
    }
    func updatePokemonName(pokemonName: String){
        pokemonNameLabel.text = pokemonName
    }
    
    func updatePokemonType(){//fetch(pokemonListData[1])->type.name if type.name == "normal" -> background to brown
        for pokemon in pokemonsListFromPokemonData{//How many pokemons are
            let type = pokemon.types[0].type.name
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
                    pokemonNameLabel.backgroundColor = #colorLiteral(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
                    setPokemonTextColor(.black)
        }
        }
    }
        func setPokemonBackgroundColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat){
            pokemonNameLabel.backgroundColor = .init(red: red, green: green, blue: blue, alpha: 33)
        }
        func setPokemonTextColor(_ color: UIColor){
            pokemonNameLabel.textColor = color
        }
    }

