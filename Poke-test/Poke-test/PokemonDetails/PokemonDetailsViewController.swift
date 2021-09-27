
import UIKit
import Alamofire
import AlamofireImage
import RealmSwift


class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var labelPokemonType2: UILabel!
    @IBOutlet weak var imageAndNameView: UIView!
    @IBOutlet weak var labelPokemonType: UILabel!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var labelPokemonName: UILabel!
    @IBOutlet weak var labelPokemonId: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var favouritesImage: UIImageView!
    
    var presenter: PokemonDetailsPresenterDelegate?
    var selectedPokemon : Results?
    var favouritesList: [Results] = []
    var cell: PokemonListCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        selectedPokemonInList()
        presenter?.fetchFavourites()
        checkFavourite()
        favouritesButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.favouritesView.layer.cornerRadius = 10
    }
}

//MARK: - ViewControllerDelegate methods
extension PokemonDetailsViewController: PokemonDetailsViewDelegate {
    
    //MARK: - Sets the add/delete label wether it's a favourite or not
    func addFavourite(pokemon: Results) {
        presenter?.addFavourite(pokemon: pokemon)
        favouritesButton.setTitle("Eliminar de favoritos", for: .normal)
        favouritesImage.image = UIImage(named: "emptyStar")
    }
    func deleteFavourite(pokemon: Results) {
        presenter?.deleteFavourite(pokemon: pokemon)
        favouritesButton.setTitle("Añadir a favoritos", for: .normal)
        favouritesImage.image = UIImage(named: "fullStar")
    }
    
    //MARK: - Gets the selected pokemon from the tableView
    func getSelectedPokemon(with pokemon: Results) {
        selectedPokemon = pokemon
    }
    
    //MARK: - Gets the favourite list after the fetching
    func updateDetailsViewFavourites(favourites: [Results]) {
        self.favouritesList = favourites
    }
    
    //MARK: - Updates view after fetching the details of the selected pokemon
    func updateDetailsView(pokemon: PokemonData) {
        self.labelPokemonName.text = pokemon.name.uppercased()
        self.labelPokemonType.text = pokemon.types[0].type.name.uppercased()
        self.labelPokemonId.text = "# \(pokemon.id)"
        self.paintLabel(pokemon: pokemon)
        if let downloadURL = URL(string: pokemon.sprites.front_default ?? ""){
            return  self.imagePokemon.af.setImage(withURL: downloadURL )
        }else {
            return
        }
    }
}
//MARK: - Data Manipulation Method
extension PokemonDetailsViewController{
    func selectedPokemonInList(){
        if let pokemonToFetch = selectedPokemon{
            presenter?.fetchPokemon(pokemon: pokemonToFetch)
        }else{
            return
        }
    }
}

//MARK: - Favourites button method
extension PokemonDetailsViewController{
    @objc func pressed(_ sender: UIButton!) {
        if favouritesButton.titleLabel?.text == "Añadir a favoritos"{
            addFavourite(pokemon: selectedPokemon!)
        } else if favouritesButton.titleLabel?.text == "Eliminar de favoritos"{
            deleteFavourite(pokemon: selectedPokemon!)
        }
        
    }
    
    func checkFavourite() {
        for favouritesFiltered in favouritesList{
            if favouritesFiltered.name == selectedPokemon?.name{
                favouritesButton.setTitle("Eliminar de favoritos", for: .normal)
                favouritesImage.image = UIImage(named: "emptyStar")
            }
        }
        
    }
    
}

//MARK: - Coloring methods
extension PokemonDetailsViewController{ 
    func paintLabel(pokemon: PokemonData){
        if pokemon.types.count >= 2{
            self.labelPokemonType2.text = pokemon.types[1].type.name.uppercased()
            self.paintType(label: self.labelPokemonType)
            self.paintType(label: self.labelPokemonType2)
            self.labelPokemonName.textColor = .black
        }else{
            self.paintType(label: self.labelPokemonType)
            self.setBackgroundColor(from: self.labelPokemonType, to: self.backgroundView)
            self.setBackgroundColor(from: self.labelPokemonType, to: self.imageAndNameView)
            self.setBackgroundColor(from: self.labelPokemonType, to: self.view)
            self.imageAndNameView.backgroundColor = self.labelPokemonType.backgroundColor
            self.labelPokemonType2.isHidden = true
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
    }
    
    func setPokemonTextColor(_ color: UIColor, _ label: UILabel){
        label.textColor = color
    }
    func setBackgroundColor(from: UIView, to: UIView){
        to.backgroundColor = from.backgroundColor
    }
}




