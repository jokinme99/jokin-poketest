
import UIKit
import RealmSwift

class PokemonCell: UITableViewCell { // Class in charge of the cell
    
    @IBOutlet weak var pokemonBubble: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    var pokemonManager = PokemonManager()
    var pokemon: Results?
    var favourites:RealmSwift.Results<Results>!
    var cellManagerDelegate: CellManagerDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pokemonManager.delegate = self
        favourites = DDBBManager.shared.loadFavourites()
    }
    
    override func prepareForReuse() {//Every time a cell is called with this method it will be a blank white cell
        super.prepareForReuse()
        backgroundColor = .white
        pokemonNameLabel.text = nil
        favouriteImage.image = nil
        idLabel.text = nil
    }
    
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}

//MARK: - PokemonManagerDelegate methods
extension PokemonCell: PokemonManagerDelegate{ // Methods in charge of the PokemonManagerDelegate protocol
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData) {
        self.updateCell(pokemonData: pokemon)
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Update methods
extension PokemonCell{ // Methods in charge of updating the cell
    func selectPokemons(){
        pokemonManager.fetchPokemon(namePokemon: self.pokemon!.name!)
    }
    func update(pokemon: Results){
        self.pokemon = pokemon
        selectPokemons()
        pokemonNameLabel.text = pokemon.name?.capitalized
    }
    
    func updateCell(pokemonData: PokemonData){
        let type = pokemonData.types[0].type.name
        setColor(type, pokemonNameLabel)
        let id = pokemonData.id
        idLabel.text = "#\(id)"
        setColor(type, idLabel)
        checkFavourite(pokemonData.name)
    }

}

//MARK: - Favourites methods
extension PokemonCell{ // Methods in charge of fetching the favourites
    func checkFavourite(_ name: String){
        for favourite in favourites{
            if favourite.name == name{
                favouriteImage.image = UIImage(systemName: "star.fill")
                cellManagerDelegate?.updateTableView()
            }
        }
    }
}

//MARK: - Painting methods
extension PokemonCell{ // Methods in charge of colouring the cell
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
