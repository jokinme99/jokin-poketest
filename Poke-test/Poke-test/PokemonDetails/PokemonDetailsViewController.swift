
import UIKit
import Alamofire
import AlamofireImage
import RealmSwift


class PokemonDetailsViewController: UIViewController {
    //ToDo: Make ButtonsList with scroll

    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var typesView: UIView!
    @IBOutlet weak var pokemonType1Label: UILabel!
    @IBOutlet weak var pokemonType2Label: UILabel!
    @IBOutlet weak var pokemonDescriptionView: UIView!
    @IBOutlet weak var pokemonIdLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var heightAndViewLabel: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ability1Label: UILabel!
    @IBOutlet weak var ability2Label: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var checkFavouriteImage: UIImageView!
    
    var presenter: PokemonDetailsPresenterDelegate?
    var selectedPokemon : Results?
    var favouritesList: [Results] = []
    var cell: PokemonListCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        selectedPokemonInList()
        presenter?.fetchFavourites()
        checkFavouriteImage.isHidden = true
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
        favouritesButton.setTitle("Delete from favourites", for: .normal)
        favouritesImage.image = UIImage(named: "emptyStar")
        checkFavouriteImage.isHidden = false
    }
    func deleteFavourite(pokemon: Results) {
        presenter?.deleteFavourite(pokemon: pokemon)
        favouritesButton.setTitle("Add to favourites", for: .normal)
        favouritesImage.image = UIImage(named: "fullStar")
        checkFavouriteImage.isHidden = true
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
        self.pokemonNameLabel.text = pokemon.name.uppercased()
        self.pokemonType1Label.text = pokemon.types[0].type.name.uppercased()
        self.pokemonIdLabel.text = "# \(pokemon.id)"
        self.heightLabel.text = "Height: \(pokemon.height) m"
        self.weightLabel.text = "Weight: \(pokemon.weight) kg"
        self.ability1Label.text = pokemon.abilities[0].ability.name.capitalized.uppercased()
        self.hpLabel.text = "Hp: \(pokemon.stats[0].base_stat)"
        self.attackLabel.text = "Attack: \(pokemon.stats[1].base_stat)"
        self.defenseLabel.text = "Defense: \(pokemon.stats[2].base_stat)"
        self.specialAttackLabel.text = "Special-attack: \(pokemon.stats[3].base_stat)"
        self.specialDefenseLabel.text = "Special-defense: \(pokemon.stats[4].base_stat)"
        self.speedLabel.text = "Speed: \(pokemon.stats[5].base_stat)"
        self.paintLabel(pokemon: pokemon)
        if let downloadURL = URL(string: pokemon.sprites.front_default ?? ""){
            return  self.pokemonImage.af.setImage(withURL: downloadURL )
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
        if favouritesButton.titleLabel?.text == "Add to favourites"{
            addFavourite(pokemon: selectedPokemon!)
        } else if favouritesButton.titleLabel?.text == "Delete from favourites"{
            deleteFavourite(pokemon: selectedPokemon!)
        }
        
    }
    
    func checkFavourite() {
        for favouritesFiltered in favouritesList{
            if favouritesFiltered.name == selectedPokemon?.name{
                favouritesButton.setTitle("Delete from favourites", for: .normal)
                favouritesImage.image = UIImage(named: "emptyStar")
                checkFavouriteImage.isHidden = false
            }
        }
        
    }
    
}

//MARK: - Coloring methods
extension PokemonDetailsViewController{ 
    func paintLabel(pokemon: PokemonData){
        if pokemon.types.count >= 2{
            self.pokemonType2Label.text = pokemon.types[1].type.name.uppercased() //Saved the 2nd type
            self.paintType(label: self.pokemonType1Label)
            self.paintType(label: self.pokemonType2Label)
            self.pokemonNameLabel.textColor = .black
            self.statsView.backgroundColor = .white
            //self.pokemonDescriptionView.backgroundColor = .white
            self.ability1Label.textColor = pokemonType1Label.backgroundColor
            self.heightAndViewLabel.backgroundColor = .white
            self.statsLabel.backgroundColor = .white
            if pokemon.abilities.count >= 2{
                self.ability2Label.text = pokemon.abilities[1].ability.name.uppercased() //Save the 2nd ability
                self.ability1Label.textColor = pokemonType1Label.backgroundColor
                self.ability2Label.textColor = pokemonType2Label.backgroundColor
            }else{
                self.ability2Label.isHidden = true
            }
        }else{
            self.paintType(label: self.pokemonType1Label)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonDescriptionView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.typesView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.backgroundView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.hpLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.attackLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.defenseLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.specialAttackLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.specialDefenseLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.speedLabel)
            self.ability1Label.textColor = pokemonType1Label.backgroundColor
            self.pokemonType2Label.isHidden = true
            if pokemon.abilities.count >= 2{
                self.ability2Label.text = pokemon.abilities[1].ability.name.uppercased() //Save the 2nd ability
                self.ability1Label.textColor = pokemonType1Label.backgroundColor
                self.ability2Label.textColor = pokemonType1Label.backgroundColor
            }else{
                self.ability2Label.isHidden = true
            }
            
        }
    }
    func paintType(label: UILabel){
        switch label.text?.lowercased() {
        case TypeName.normal:
            setPokemonBackgroundColor(168, 168, 120, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
            setPokemonTextColor(.white, label)
        case TypeName.fight:
            setPokemonBackgroundColor(192, 48, 40, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.flying:
            setPokemonBackgroundColor(168, 144, 240, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.poison:
            setPokemonBackgroundColor(160, 64, 160, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.ground:
            setPokemonBackgroundColor(224, 192, 104, label)
            setPokemonTextColor(.black, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.rock:
            setPokemonBackgroundColor(184, 160, 56, label)
            setPokemonTextColor(.black, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.bug:
            setPokemonBackgroundColor(168, 184, 32, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.ghost:
            setPokemonBackgroundColor(112, 88, 152, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.steel:
            setPokemonBackgroundColor(184, 184, 208, label)
            setPokemonTextColor(.black, label)
        case TypeName.fire:
            setPokemonBackgroundColor(240, 128, 48, label)
            setPokemonTextColor(.black, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.water:
            setPokemonBackgroundColor(104, 144, 240, label)
            setPokemonTextColor(.white, label)
        case TypeName.grass:
            setPokemonBackgroundColor(120, 200, 80, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.electric:
            setPokemonBackgroundColor(248, 208, 48, label)
            setPokemonTextColor(.black, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.psychic:
            setPokemonBackgroundColor(248, 88, 136, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.ice:
            setPokemonBackgroundColor(152, 216, 216, label)
            setPokemonTextColor(.black, label)
            break
        case TypeName.dragon:
            setPokemonBackgroundColor(112, 56, 248, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.dark:
            setPokemonBackgroundColor(112, 88, 72, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.fairy:
            setPokemonBackgroundColor(238, 153, 172, label)
            setPokemonTextColor(.black, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
        case TypeName.unknown:
            setPokemonBackgroundColor(0, 0, 0, label)
            setPokemonTextColor(.white, label)
        case TypeName.shadow:
            setPokemonBackgroundColor(124, 110, 187, label)
            setPokemonTextColor(.white, label)
            checkFavouriteImage.image = UIImage(named: "fullStar")
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




