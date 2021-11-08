
import UIKit

class PokemonCell: UITableViewCell {
    
    @IBOutlet weak var pokemonBubble: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var favouriteImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    
    var pokemon: Results?
    var favouritesList: [Favourites] = []
    var view: PokemonListViewDelegate?
    var presenter: PokemonListPresenterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func prepareForReuse() {
        //Every time a cell is called with this method it will be a blank white cell
        super.prepareForReuse()
        backgroundColor = .white
        pokemonNameLabel.text = nil
        favouriteImage.image = nil
        idLabel.text = nil
    }
    
}

//MARK: - CellDelegate methods
extension PokemonCell: PokemonListCellDelegate{
    
    //MARK: - Sets each pokemon cell
    func updatePokemonInCell(pokemonToFetch: Results) {
        self.pokemon = pokemonToFetch
        if Reachability.isConnectedToNetwork(){
            PokemonManager.shared.fetchPokemon(pokemonSelectedName: pokemonToFetch.name!,{ pokemonData, error in
                if let error = error {
                    print(error)
                }else{
                    guard let pokemonData = pokemonData else {return}
                    self.setColor((pokemonData.types[0].type?.name ?? "default"), self.pokemonNameLabel)
                    self.idLabel.text = "#\(pokemonData.id)"
                    self.setColor((pokemonData.types[0].type?.name ?? "default"), self.idLabel)
                }
            })
        }else{
            let pokemonDataList = DDBBManager.shared.get(PokemonData.self)
            for pokemonData in pokemonDataList {
                if pokemonData.name == pokemonToFetch.name {
                    guard let typeName = pokemonData.types[0].type?.name else{return}
                    self.setColor((pokemonData.types[0].type?.name ?? "default"), self.pokemonNameLabel)
                    self.idLabel.text = "#\(pokemonData.id)"
                    self.setColor((pokemonData.types[0].type?.name ?? "default"), self.idLabel)
                }
                
            }
        }
      
        self.pokemonNameLabel.text = pokemonToFetch.name?.capitalized
        self.checkIfFavouritePokemon(pokemonToCheck: pokemonToFetch)
    }
    
    
    //MARK: - Checks favourite pokemons
    func checkIfFavouritePokemon(pokemonToCheck: Results){
        for favourite in self.favouritesList{
            if favourite.name == pokemonToCheck.name{
                self.favouriteImage.image = imageWithImage(image: UIImage(named: "fullStar")!, scaledToSize: CGSize(width: 20, height: 20))
            }
        }
        //guard let dictionary = dictionary else{return}
        //self.vc?.pokemonIdAndNames = dictionary
        //self.view?.updateTableViewFavourites()
    }
}

//MARK: - Painting methods
extension PokemonCell{
    
    //MARK: - Sets an image size
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
    
    //MARK: - Paints cell background
    func setPokemonBackgroundColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ label: UILabel){
        label.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    //MARK: - Paints cell text color
    func setPokemonTextColor(_ color: UIColor){
        pokemonNameLabel.textColor = color
    }
    
    //MARK: - Paints cell combining the background color and the text color
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

