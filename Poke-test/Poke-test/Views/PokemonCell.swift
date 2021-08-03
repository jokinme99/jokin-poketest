
import UIKit

class PokemonCell: UITableViewCell {
    
    @IBOutlet weak var pokemonBubble: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    //@IBOutlet weak var colorLabel: UILabel!
    var pokemonManager = PokemonManager()
    var pokemon: Results?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pokemonManager.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
        pokemonNameLabel.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
//MARK: - PokemonManagerDelegate methods
extension PokemonCell: PokemonManagerDelegate{
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData) {
        self.updatePokemonType(pokemonData: pokemon)
        
        //self.pokemonsListFromPokemonData.append(pokemon)//Save the pokemons
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
//MARK: - Update methods
extension PokemonCell{
    func selectPokemons(){//Calls the fetch method a number of times, the number of times called is how many names exist
        pokemonManager.fetchPokemon(namePokemon: self.pokemon!.name!)
    }
    func updatePokemonName(pokemonName: String){
        pokemonNameLabel.text = pokemonName
    }
    
    func update(pokemon: Results){
        self.pokemon = pokemon
        selectPokemons()
        pokemonNameLabel.text = pokemon.name?.capitalized
    }
    
    func updatePokemonType(pokemonData: PokemonData){//fetch(pokemonListData[1])->type.name if type.name == "normal" -> background to brown
//        if pokemonData.types.count >= 2{
//            let type1 = pokemonData.types[0].type.name
//            let type2 = pokemonData.types[1].type.name
//            setColor(type1, pokemonNameLabel)
//            setColor(type2, colorLabel)
//        }else{
            //colorLabel.isHidden = true
            let type = pokemonData.types[0].type.name
            setColor(type, pokemonNameLabel)
//        }
    

    }
}
//MARK: - Painting methods
extension PokemonCell{
    func setPokemonBackgroundColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ label: UILabel){
        label.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    func setPokemonTextColor(_ color: UIColor){
        pokemonNameLabel.textColor = color
    }
    func setColor(_ type: String, _ label: UILabel){
        switch type {
        case TypeName.normal:
            setPokemonBackgroundColor(168, 168, 120, label)
            setPokemonTextColor(.white)
        case TypeName.fight:
            setPokemonBackgroundColor(192, 48, 40, label)
            setPokemonTextColor(.white)
        case TypeName.flying:
            setPokemonBackgroundColor(168, 144, 240, label)
            setPokemonTextColor(.white)
        case TypeName.poison:
            setPokemonBackgroundColor(160, 64, 160, label)
            setPokemonTextColor(.white)
        case TypeName.ground:
            setPokemonBackgroundColor(224, 192, 104, label)
            setPokemonTextColor(.black)
        case TypeName.rock:
            setPokemonBackgroundColor(184, 160, 56, label)
            setPokemonTextColor(.black)
        case TypeName.bug:
            setPokemonBackgroundColor(168, 184, 32, label)
            setPokemonTextColor(.white)
        case TypeName.ghost:
            setPokemonBackgroundColor(112, 88, 152, label)
            setPokemonTextColor(.white)
        case TypeName.steel:
            setPokemonBackgroundColor(184, 184, 208, label)
            setPokemonTextColor(.black)
        case TypeName.fire:
            setPokemonBackgroundColor(240, 128, 48, label)
            setPokemonTextColor(.black)
        case TypeName.water:
            setPokemonBackgroundColor(104, 144, 240, label)
            setPokemonTextColor(.white)
        case TypeName.grass:
            setPokemonBackgroundColor(120, 200, 80, label)
            setPokemonTextColor(.white)
        case TypeName.electric:
            setPokemonBackgroundColor(248, 208, 48, label)
            setPokemonTextColor(.black)
        case TypeName.psychic:
            setPokemonBackgroundColor(248, 88, 136, label)
            setPokemonTextColor(.white)
        case TypeName.ice:
            setPokemonBackgroundColor(152, 216, 216, label)
            setPokemonTextColor(.black)
        case TypeName.dragon:
            setPokemonBackgroundColor(112, 56, 248, label)
            setPokemonTextColor(.white)
        case TypeName.dark:
            setPokemonBackgroundColor(112, 88, 72, label)
            setPokemonTextColor(.white)
        case TypeName.fairy:
            setPokemonBackgroundColor(238, 153, 172, label)
            setPokemonTextColor(.black)
        case TypeName.unknown:
            setPokemonBackgroundColor(0, 0, 0, label)
            setPokemonTextColor(.white)
        case TypeName.shadow:
            setPokemonBackgroundColor(124, 110, 187, label)
            setPokemonTextColor(.white)
        default:
            pokemonNameLabel.backgroundColor = #colorLiteral(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
            setPokemonTextColor(.black)
        }
    }
}

