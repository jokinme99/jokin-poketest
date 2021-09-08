
import UIKit
import Alamofire
import AlamofireImage
import RealmSwift

class DetailViewController: UIViewController { // Class in charge of the details of a specified pokemon
    
    @IBOutlet weak var imagePokemon: UIImageView!
    @IBOutlet weak var labelPokemonName: UILabel!
    @IBOutlet weak var labelPokemonType: UILabel!
    @IBOutlet weak var labelPokemonType2: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var imageAndNameView: UIView!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var labelPokemonId: UILabel!
   
    var selectedPokemon : Results? {
        didSet{
            selectedPokemonInList()
        }
    }
    var favourites:RealmSwift.Results<Results>!
    var favouritesManager : DDBBManagerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PokemonManager.shared.delegate = self
        favourites = DDBBManager.shared.loadFavourites()
        selectedPokemonInList()
        loadFavouritesSettings()
    }
}

//MARK: - PokemonDelegate Methods
extension DetailViewController: PokemonManagerDelegate{ // Method in charge of the methods inside the PokemonManagerDelegate protocol
    func didUpdatePokemon(_ pokemonManager: PokemonManager, pokemon: PokemonData) {
        DispatchQueue.main.async {
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
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - Data Manipulation Method
extension DetailViewController{ //Method in charge of fetching the details of the specified pokemon
    func selectedPokemonInList(){
        if let namePokemon = selectedPokemon?.name{
            PokemonManager.shared.fetchPokemon(namePokemon: namePokemon)
        }else{
            return
        }
    }
}

//MARK: - Favourites button method
extension DetailViewController{ //Methods in charge of the favourites button
    @objc func pressed(_ sender: UIButton!) {
        switch favouritesButton.titleLabel?.text {
        case "Añadir a favoritos":
            favouritesButton.setTitle("Eliminar de favoritos", for: .normal)
            favouritesImage.image = UIImage(systemName: "star")
            editFavourite(selectedPokemon!)
        case "Eliminar de favoritos":
            favouritesButton.setTitle("Añadir a favoritos", for: .normal)
            favouritesImage.image = UIImage(systemName: "star.fill")
            editFavourite(selectedPokemon!)
        default:
            favouritesButton.setTitle("Añadir a favoritos", for: .normal)
            favouritesImage.image = UIImage(systemName: "star.fill")
        }
        
    }
    func checkFavourite() {
        for favouritesFiltered in favourites{
            if favouritesFiltered.name == selectedPokemon?.name{
                favouritesButton.setTitle("Eliminar de favoritos", for: .normal)
                favouritesImage.image = UIImage(systemName: "star")
            }
        }
    }
    func loadFavouritesSettings(){
        checkFavourite()
        favouritesButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.favouritesView.layer.cornerRadius = 10
    }

}

//MARK: - Edit Favourites methods
extension DetailViewController{ // Methods in charge of editing favourites
    func editFavourite(_ favourite: Results){
        let isSaved = isSavedFavourite(favourite)
        if !isSaved.isSaved{ // If it doesn't exist,  it is added
            let saved = Results()
            saved.name = favourite.name
            DDBBManager.shared.save(saved) { (error) in
                self.favouritesManager?.didSaveFavouriteWithError(error: error)
            }
        }else{
            if let saved = isSaved.saved{//If it exists,  it is deleted
                DDBBManager.shared.delete(saved){ (error) in
                    self.favouritesManager?.didDeleteFavouriteWithError(error: error)
                }
            }
        }
    }
    func isSaved(favourite: Results){ // Method that checks if favourite is saved already
        let saved = isSavedFavourite(favourite)
        favouritesManager?.didIsSaved(saved: saved.isSaved)
    }
    private func isSavedFavourite(_ favourite: Results) ->(isSaved: Bool, saved: Results?){ //Method that returns the first object with the searched data
        let filter = "name == '\(favourite.name!)'"
        let saved = DDBBManager.shared.get(Results.self, filter: filter)
        return (saved.count > 0, saved.first)
    }
}

//MARK: - Coloring methods
extension DetailViewController{ // Methods in charge of the colouring of the UIViewController
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
