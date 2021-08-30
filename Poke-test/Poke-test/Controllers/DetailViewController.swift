
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
   
    let vc = PokemonCell()
    var pokemonManager = PokemonManager()
    var selectedPokemon : Results? {
        didSet{
            selectedPokemonInList()
        }
    }
    var realm = try! Realm()//favourites
    var favourites:RealmSwift.Results<Results>!
    var arrayOfFavouritePokemonNames: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        pokemonManager.delegate = self
        selectedPokemonInList()
        loadFavourites()
        favouritesButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.favouritesView.layer.cornerRadius = 10
        
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
            pokemonManager.fetchPokemon(namePokemon: namePokemon)
        }else{
            return
        }
    }
}

//MARK: - Favourites method
extension DetailViewController{ //Methods in charge of the favourites button
    @objc func pressed(_ sender: UIButton!) {
        switch favouritesButton.titleLabel?.text {
        case "Añadir a favoritos":
            favouritesButton.setTitle("Eliminar de favoritos", for: .normal)
            favouritesImage.image = UIImage(systemName: "star")
            saveToFavourites(selectedPokemon!)
        case "Eliminar de favoritos":
            favouritesButton.setTitle("Añadir a favoritos", for: .normal)
            favouritesImage.image = UIImage(systemName: "star.fill")
            removeFavourite(selectedPokemon!)
        default:
            favouritesButton.setTitle("Añadir a favoritos", for: .normal)
            favouritesImage.image = UIImage(systemName: "star.fill")
        }
        
    }
    func loadFavourites(){
        favourites = realm.objects(Results.self)
        for favouritesFiltered in favourites{
            arrayOfFavouritePokemonNames.append(favouritesFiltered.name!)
            if favouritesFiltered.name == selectedPokemon?.name{
                favouritesButton.setTitle("Eliminar de favoritos", for: .normal)
                favouritesImage.image = UIImage(systemName: "star")
            }
        }
    }
    
    func saveToFavourites(_ pokemon: Results) { //ToDo: When adding favourite the star must appear
        do{
            if arrayOfFavouritePokemonNames.contains(pokemon.name!) != true{
                try realm.write{
                    realm.add(pokemon)
                    
                    
                }
                vc.setFavouriteIcon(pokemon.name!)
            }else{
                print("Pokemon already added to favourites")
            }
            loadFavourites()
            
        }catch{
            print("Error saving pokemon into favourites")
        }
        
    }
    
    func removeFavourite(_ pokemon: Results){//Not working
        do{
            if arrayOfFavouritePokemonNames.contains(pokemon.name!) == true{
                let pokemonSelected = favourites.filter("name = %@", pokemon.name!).first
                try realm.write{
                    if let pokemonToDelete = pokemonSelected{
                        realm.delete(pokemonToDelete)
                    }
                }
                vc.setFavouriteIcon(pokemon.name!)
                
            }else{
                print("Not added to favourites")
            }
            loadFavourites()
        }catch{
            print("Error deleating favourite")
        }
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
