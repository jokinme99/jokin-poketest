
import UIKit
import AlamofireImage
import RealmSwift


class PokemonDetailsViewController: UIViewController {
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
    @IBOutlet weak var favouriteConfirmationImage: UIImageView!
    @IBOutlet weak var nextOrPreviewView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var presenter: PokemonDetailsPresenterDelegate?
    var listPresenter: PokemonListPresenterDelegate?
    var selectedPokemon : Results?
    var previousPokemon: Results?
    var nextPokemon: Results?
    var favouritesList: [Favourites] = []
    var cell: PokemonListCellDelegate?
    var filtered: [Results] = []
    var row : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        loadSelectedPokemon()
        presenter?.fetchFavourites()
        loadMethods()
        row = (filtered.firstIndex(of: selectedPokemon!))
    }
}

//MARK: - Load methods
extension PokemonDetailsViewController{
    func loadSelectedPokemon(){
        if let pokemonToFetch = selectedPokemon{
            presenter?.fetchPokemon(pokemon: pokemonToFetch)
        }else{
            return
        }
    }
    func loadMethods(){
        self.loadButtonsStyle()
        self.presenter?.fetchFavourites()
        self.favouriteConfirmationImage.isHidden = false
        self.favouritesButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.previewButton.addTarget(self, action: #selector(previousPokemonButtonAction), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextPokemonButtonAction), for: .touchUpInside)
        if filtered.count < 2{
            nextButton.isHidden = true
            previewButton.isHidden = true
        }
        self.nextButton.setTitle(self.nextPokemon?.name?.capitalized, for: .normal)
        self.previewButton.setTitle(self.previousPokemon?.name?.capitalized, for: .normal)
    }
    func loadButtonsStyle(){
        self.previewButton.layer.cornerRadius = 5
        self.previewButton.layer.borderWidth = 2
        self.previewButton.layer.borderColor = UIColor.black.cgColor
        self.nextButton.layer.cornerRadius = 5
        self.nextButton.layer.borderWidth = 2
        self.nextButton.layer.borderColor = UIColor.black.cgColor
    }
}

//MARK: - ViewControllerDelegate methods
extension PokemonDetailsViewController: PokemonDetailsViewDelegate {
    
    //MARK: - Sets the add/delete label wether it's a favourite or not
    func addFavourite(pokemon: Results) {
        presenter?.addFavourite(pokemon: pokemon)
        favouritesButton.setTitle("Delete from favourites", for: .normal)
        favouritesImage.image = UIImage(named: "emptyStar")
        favouriteConfirmationImage.isHidden = false
    }
    func deleteFavourite(pokemon: Results) {
        let filt = filtered.map{$0.name}
        let fav = favouritesList.map{$0.name}
        if filt == fav{ //It has to be deleted from filtered
            favouritesButton.setTitle("Add to favourites", for: .normal)
            favouritesImage.image = UIImage(named: "fullStar")
            favouriteConfirmationImage.isHidden = true
            presenter?.deleteFavourite(pokemon: pokemon)
            let index = filtered.firstIndex(of: pokemon)
            filtered.remove(at: index!)
            presenter?.fetchFavourites()
            if filtered.count == 1{
                self.previewButton.isHidden = true
                self.nextButton.isHidden = true
            }
            
        }else{
            presenter?.deleteFavourite(pokemon: pokemon)
            favouritesButton.setTitle("Add to favourites", for: .normal)
            favouritesImage.image = UIImage(named: "fullStar")
            favouriteConfirmationImage.isHidden = true
            presenter?.fetchFavourites()
            
            
        }
        
    }
    
    //MARK: - Gets the selected pokemon from the tableView
    func getSelectedPokemon(with pokemon: Results) {
        selectedPokemon = pokemon
    }
    
    //MARK: - Gets the favourite list after the fetching
    func updateDetailsViewFavourites(favourites: [Favourites]) {
        self.favouritesList = favourites
    }
    
    //MARK: - Updates view after fetching the details of the selected pokemon
    func updateDetailsView(pokemon: PokemonData) {
        favouriteConfirmationImage.isHidden = true
        presenter?.fetchFavourites()
        for favouritesFiltered in favouritesList{
            if favouritesFiltered.name == pokemon.name{
                favouritesButton.setTitle("Delete from favourites", for: .normal)
                favouritesImage.image = UIImage(named: "emptyStar")
                favouriteConfirmationImage.isHidden = false
                break
            }else{
                favouritesButton.setTitle("Add to favourites", for: .normal)
                favouritesImage.image = UIImage(named: "fullStar")
                favouriteConfirmationImage.isHidden = true
            }
        }
        paintWindow(pokemon)
    }
    func paintWindow(_ pokemon: PokemonData){//Fix image and filters (offline)
        let type = pokemon.types[0]
        self.pokemonNameLabel.text = pokemon.name?.uppercased()
        self.pokemonType1Label.text = type.type?.name?.uppercased()
        self.pokemonIdLabel.text = "# \(pokemon.id)"
        self.heightLabel.text = "Height: \(pokemon.height) m"
        self.weightLabel.text = "Weight: \(pokemon.weight) kg"
        self.ability1Label.text = pokemon.abilities[0].ability?.name!.capitalized.uppercased()
        self.hpLabel.text = "Hp: \(pokemon.stats[0].base_stat)"
        self.attackLabel.text = "Attack: \(pokemon.stats[1].base_stat)"
        self.defenseLabel.text = "Defense: \(pokemon.stats[2].base_stat)"
        self.specialAttackLabel.text = "Special-attack: \(pokemon.stats[3].base_stat)"
        self.specialDefenseLabel.text = "Special-defense: \(pokemon.stats[4].base_stat)"
        self.speedLabel.text = "Speed: \(pokemon.stats[5].base_stat)"
        self.paintLabel(pokemon: pokemon)
        if let downloadURL = URL(string: pokemon.sprites?.front_default ?? ""){// change-> ?
            let image = self.pokemonImage.af.setImage(withURL: downloadURL)
            return image
        }else {
            return
        }
    }
}

//MARK: - Buttons methods
extension PokemonDetailsViewController{
    @objc func pressed(_ sender: UIButton!) {
        if favouritesButton.titleLabel?.text == "Add to favourites"{
            addFavourite(pokemon: selectedPokemon!)
        } else if favouritesButton.titleLabel?.text == "Delete from favourites"{
            deleteFavourite(pokemon: selectedPokemon!)
        }
    }
    @objc func nextPokemonButtonAction(_ sender: UIButton!){
        guard let nextPokemon = nextPokemon else{return}
        presenter?.fetchPokemon(pokemon: nextPokemon)
        if row == filtered.count - 1{ // if we're in the last row, and we press next actualRow will be the first
            row = 0
        }else{
            row = row! + 1 // if we do guard let row = row or row ?? 0 doesn't work
        }
        nextOrPrevious()
        
        
    }
    @objc func previousPokemonButtonAction(_ sender: UIButton!){
        guard let previousPokemon = previousPokemon else{return}
        presenter?.fetchPokemon(pokemon: previousPokemon)
        if row == 0{ // if we're in the first row, and we press previous actualRow will be the last
            row = filtered.count - 1
        }else{
            row = row!  - 1 // if we do guard let row = row or row ?? 0 doesn't work
        }
        nextOrPrevious()
        
    }
    func nextOrPrevious(){
        guard let row = row else{return}
        if filtered.count < 3{
            if row == 0{
                self.selectedPokemon = filtered[row]
                self.previousPokemon = filtered.last
                self.nextPokemon = previousPokemon
                self.selectedPokemon = filtered[row]
                self.nextPokemon = filtered.first
                self.previousPokemon = nextPokemon
            }
        }else if filtered.count == 1{
            
            self.previewButton.isHidden = true
            self.nextButton.isHidden = true
        }else{
            if row == 0{
                self.selectedPokemon = filtered[row]
                self.nextPokemon = filtered[row + 1]
                self.previousPokemon = filtered.last
            }else if row == filtered.count - 1{
                self.selectedPokemon = filtered[row]
                self.previousPokemon = filtered[row - 1]
                self.nextPokemon = filtered.first
            }else{
                self.nextPokemon = filtered[row  + 1]
                self.selectedPokemon = filtered[row]
                self.previousPokemon = filtered[row - 1]
            }
        }
        self.nextButton.setTitle(self.nextPokemon?.name?.capitalized, for: .normal)
        self.previewButton.setTitle(self.previousPokemon?.name?.capitalized, for: .normal)
        presenter?.fetchFavourites()
    }
}

//MARK: - Coloring methods
extension PokemonDetailsViewController{
    func paintLabel(pokemon: PokemonData){
        if pokemon.types.count >= 2{
            self.pokemonType2Label.isHidden = false
            self.pokemonType2Label.text = pokemon.types[1].type?.name!.uppercased() //Saved the 2nd type
            self.paintType(label: self.pokemonType1Label)
            self.paintType(label: self.pokemonType2Label)
            self.pokemonDescriptionView.backgroundColor = UIColor(named: "grayColor")
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.typesView)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.backgroundView)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.hpLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.attackLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.defenseLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.specialAttackLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.specialDefenseLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.speedLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.nextOrPreviewView)
            self.pokemonNameLabel.textColor = .black
            self.heightLabel.textColor = .black
            self.weightLabel.textColor = .black
            self.statsView.backgroundColor = .white
            self.ability1Label.textColor = pokemonType1Label.backgroundColor
            self.heightAndViewLabel.backgroundColor = .white
            self.statsLabel.backgroundColor = .white
            self.nextButton.titleLabel?.textColor = .black
            self.nextButton.backgroundColor = pokemonDescriptionView.backgroundColor
            self.previewButton.titleLabel?.textColor = .black
            self.previewButton.backgroundColor = pokemonDescriptionView.backgroundColor
            if pokemon.abilities.count >= 2{
                self.ability2Label.text = pokemon.abilities[1].ability?.name!.uppercased() //Save the 2nd ability
                self.ability1Label.textColor = pokemonType1Label.backgroundColor
                self.ability2Label.textColor = pokemonType2Label.backgroundColor
            }else{
                self.ability2Label.isHidden = true
            }
        } else{
            self.paintType(label: self.pokemonType1Label)
            self.pokemonType2Label.isHidden = true
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonDescriptionView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.typesView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.backgroundView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.hpLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.attackLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.defenseLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.specialAttackLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.specialDefenseLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.speedLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.nextOrPreviewView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.nextButton)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.previewButton)
            self.ability1Label.textColor = pokemonType1Label.backgroundColor
            
            if pokemon.abilities.count >= 2{
                self.ability2Label.text = pokemon.abilities[1].ability?.name!.uppercased() //Save the 2nd ability
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
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
            setPokemonTextColor(.white, label)
        case TypeName.fight:
            setPokemonBackgroundColor(192, 48, 40, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.flying:
            setPokemonBackgroundColor(168, 144, 240, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.poison:
            setPokemonBackgroundColor(160, 64, 160, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.ground:
            setPokemonBackgroundColor(224, 192, 104, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.rock:
            setPokemonBackgroundColor(184, 160, 56, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.bug:
            setPokemonBackgroundColor(168, 184, 32, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.ghost:
            setPokemonBackgroundColor(112, 88, 152, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.steel:
            setPokemonBackgroundColor(184, 184, 208, label)
            setPokemonTextColor(.black, label)
        case TypeName.fire:
            setPokemonBackgroundColor(240, 128, 48, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.water:
            setPokemonBackgroundColor(104, 144, 240, label)
            setPokemonTextColor(.white, label)
        case TypeName.grass:
            setPokemonBackgroundColor(120, 200, 80, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.electric:
            setPokemonBackgroundColor(248, 208, 48, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.psychic:
            setPokemonBackgroundColor(248, 88, 136, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.ice:
            setPokemonBackgroundColor(152, 216, 216, label)
            setPokemonTextColor(.black, label)
            break
        case TypeName.dragon:
            setPokemonBackgroundColor(112, 56, 248, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.dark:
            setPokemonBackgroundColor(112, 88, 72, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.fairy:
            setPokemonBackgroundColor(238, 153, 172, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.unknown:
            setPokemonBackgroundColor(0, 0, 0, label)
            setPokemonTextColor(.white, label)
        case TypeName.shadow:
            setPokemonBackgroundColor(124, 110, 187, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
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




