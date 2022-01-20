
import UIKit
import AlamofireImage
import RealmSwift
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics
import Zero


//MARK: - PokemonDetailsViewController
class PokemonDetailsViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var typesView: UIView!
    @IBOutlet weak var pokemonType1Label: UILabel!
    @IBOutlet weak var pokemonType2Label: UILabel!
    @IBOutlet weak var nextOrPreviewView: UIView!
    @IBOutlet weak var previewButton: ZeroContainedButton!
    @IBOutlet weak var nextButton: ZeroContainedButton!
    @IBOutlet weak var pokemonDescriptionView: UIView!
    @IBOutlet weak var pokemonIdLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var heightAndWeightView: UIView!
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
    @IBOutlet weak var favouritesButton: ZeroOutlineButton!
    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var favouriteConfirmationImage: UIImageView!

    
    var presenter: PokemonDetailsPresenterDelegate?
    var listPresenter: PokemonListPresenterDelegate?
    var selectedPokemon : Results?
    var previousPokemon: Results?
    var nextPokemon: Results?
    var favouritesList: [Favourites] = []
    var cell: PokemonCellDelegate?
    var filtered: [Results] = []
    var row : Int?
    let user = Auth.auth().currentUser
    var arrayOfNames: [String] = []
    var alert = ZeroDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        presenter?.fetchFavourites()
        loadSelectedPokemon()
        loadMethods()
        guard let selectedPokemon = selectedPokemon else {return}
        row = (filtered.firstIndex(of: selectedPokemon))
        crashlyticsErrorSending()
        loadImageAction()
    }
}


//MARK: - ViewDidLoad methods
extension PokemonDetailsViewController{
    
    
    //MARK: - loadSelectedPokemon
    func loadSelectedPokemon(){
        if let pokemonToFetch = selectedPokemon{
            presenter?.fetchPokemon(pokemon: pokemonToFetch)
        }else{
            return
        }
    }
    
    
    //MARK: - isFavourite
    func isFavourite(){
        for fav in favouritesList{
            guard let name = fav.name else {return}
            if arrayOfNames.contains(name) == false{
                arrayOfNames.append(name)
            }
            
        }
        guard let name = selectedPokemon?.name else{return}
        if arrayOfNames.contains(name){
            favouritesButton.setTitle(NSLocalizedString("delete_from_favourites", comment: ""), for: .normal)
          favouritesImage.image = UIImage(named: "emptyStar")
          favouriteConfirmationImage.isHidden = false

        }else{
            favouritesButton.setTitle(NSLocalizedString("add_to_favourites", comment: ""), for: .normal)
            favouritesImage.image = UIImage(named: "fullStar")
            favouriteConfirmationImage.isHidden = true
            
        }
    }
    
    
    //MARK: - loadMethods
    func loadMethods(){
        self.loadStyle()
        self.favouritesButton.addTarget(self, action: #selector(addToFavouritesPressed), for: .touchUpInside)
        self.previewButton.addTarget(self, action: #selector(previousPokemonButtonAction), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextPokemonButtonAction), for: .touchUpInside)
        if filtered.count < 2{
            nextButton.isHidden = true
            previewButton.isHidden = true
        }
        self.nextButton.setTitle(self.nextPokemon?.name?.capitalized, for: .normal)
        self.previewButton.setTitle(self.previousPokemon?.name?.capitalized, for: .normal)
    }
    
    
    //MARK: - loadImageAction
    func loadImageAction(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pokemonImage.isUserInteractionEnabled = true
        pokemonImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
  
    
    
    //MARK: - loadButtonsStyle
    func loadStyle(){
        self.previewButton.layer.cornerRadius = 5
        self.previewButton.layer.borderWidth = 2
        self.previewButton.layer.borderColor = UIColor.black.cgColor
        self.nextButton.layer.cornerRadius = 5
        self.nextButton.layer.borderWidth = 2
        self.nextButton.layer.borderColor = UIColor.black.cgColor
        self.statsView.layer.cornerRadius = 5
        self.favouritesView.layer.cornerRadius = 5
        self.favouritesButton.layer.borderWidth = 0
        self.pokemonType1Label.apply(ZeroTheme.Label.head2)
        self.pokemonType2Label.apply(ZeroTheme.Label.head2)
        self.nextButton.apply(ZeroTheme.Button.normal)
        self.previewButton.apply(ZeroTheme.Button.normal)
        self.previewButton.setTitleColor(.black, for: .normal)
        self.nextButton.setTitleColor(.black, for: .normal)
        self.pokemonIdLabel.apply(ZeroTheme.Label.head4)
        self.pokemonNameLabel.apply(ZeroTheme.Label.head4Bold)
        self.statsLabel.apply(ZeroTheme.Label.body1)
        self.weightLabel.apply(ZeroTheme.Label.body2)
        self.heightLabel.apply(ZeroTheme.Label.body2)
        self.ability1Label.apply(ZeroTheme.Label.body2Bold)
        self.ability2Label.apply(ZeroTheme.Label.body2Bold)
        self.hpLabel.apply(ZeroTheme.Label.body2)
        self.attackLabel.apply(ZeroTheme.Label.body2)
        self.defenseLabel.apply(ZeroTheme.Label.body2)
        self.specialAttackLabel.apply(ZeroTheme.Label.body2)
        self.specialDefenseLabel.apply(ZeroTheme.Label.body2)
        self.speedLabel.apply(ZeroTheme.Label.body2)
        self.favouritesButton.apply(ZeroTheme.Button.outlined)
    }
    
    
    
    //MARK: - crashlyticsErrorSending
    func crashlyticsErrorSending(){
        //Enviar email del usuario
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        //Enviar claves personalizadas
        Crashlytics.crashlytics().setCustomValue(email, forKey: "USER")
        //Enviar logs de errores
        Crashlytics.crashlytics().log("Error in PokemonDetailsViewController")
    }
}


//MARK: - PokemonDetailsViewDelegate methods
extension PokemonDetailsViewController: PokemonDetailsViewDelegate {
    
    
    //MARK: - addFavourite
    func addFavourite(pokemon: Results) {
        favouritesButton.setTitle(NSLocalizedString("delete_from_favourites", comment: ""), for: .normal)
        favouritesImage.image = UIImage(named: "emptyStar")
        favouriteConfirmationImage.isHidden = false
    }
    
    
    //MARK: - deleteFavourite
    func deleteFavourite(pokemon: Results) {
        let filt = filtered.map{$0.name}
        let fav = favouritesList.map{$0.name}
        if filt == fav{ //It has to be deleted from filtered
            favouritesButton.setTitle(NSLocalizedString("add_to_favourites", comment: ""), for: .normal)
            favouritesImage.image = UIImage(named: "fullStar")
            favouriteConfirmationImage.isHidden = true
            let index = filtered.firstIndex(of: pokemon)
            guard let index = index else {return}
            filtered.remove(at: index)
            presenter?.fetchFavourites()
            if filtered.count == 1{
                self.previewButton.isHidden = true
                self.nextButton.isHidden = true
            }
        }else{//Si añades y luego eliminas Error
            if arrayOfNames.isEmpty == false{
                let indexName = arrayOfNames.firstIndex(of: pokemon.name ?? "default")
                arrayOfNames.remove(at: indexName ?? 0)
            }
            favouritesButton.setTitle(NSLocalizedString("add_to_favourites", comment: ""), for: .normal)
            favouritesImage.image = UIImage(named: "fullStar")
            favouriteConfirmationImage.isHidden = true
            presenter?.fetchFavourites()
            
        }
        
    }
    
    
    //MARK: - getSelectedPokemon
    func getSelectedPokemon(with pokemon: Results) {
        selectedPokemon = pokemon
    }
    
    
    //MARK: - updateDetailsViewFavourites
    func updateDetailsViewFavourites(favourites: [Favourites]) {
        self.favouritesList = favourites
        isFavourite()
    }
    
    
    //MARK: - updateDetailsView
    func updateDetailsView(pokemon: PokemonData) {
        paintWindow(pokemon)
    }
    
    
    //MARK: - paintWindow
    func paintWindow(_ pokemon: PokemonData){
        let type = pokemon.types[0]
        self.pokemonNameLabel.text = pokemon.name?.uppercased()
        self.pokemonType1Label.text = type.type?.name?.uppercased()
        self.pokemonIdLabel.text = "# \(pokemon.id)"
        self.heightLabel.text = NSLocalizedString("Height", comment: "") + "\(pokemon.height) m"
        self.weightLabel.text = NSLocalizedString("Weight", comment: "") + " \(pokemon.weight) kg"
        guard let abilityName = pokemon.abilities[0].ability?.name else{return}
        self.ability1Label.text = abilityName.capitalized.uppercased()
        self.hpLabel.text = " Hp: \(pokemon.stats[0].base_stat)"
        self.attackLabel.text = NSLocalizedString(" Attack", comment: "") + ":" + "\(pokemon.stats[1].base_stat)"
        self.defenseLabel.text = NSLocalizedString(" Defense", comment: "") + ": " +  "\(pokemon.stats[2].base_stat)"
        self.specialAttackLabel.text = NSLocalizedString(" Special_attack", comment: "") + ": " + "\(pokemon.stats[3].base_stat)"
        self.specialDefenseLabel.text = NSLocalizedString(" Special_defense", comment: "") + ": " + "\(pokemon.stats[4].base_stat)"
        self.speedLabel.text = NSLocalizedString(" Speed", comment: "") + ": " + "\(pokemon.stats[5].base_stat)"
        self.paintLabel(pokemon: pokemon)
        self.transformUrlToImage(url: pokemon.sprites?.front_default ?? "")
    }
    
    
    //MARK: - transformUrlToImage
    func transformUrlToImage(url: String){
        if let downloadURL = URL(string: url){
            if Reachability.isConnectedToNetwork(){
                return self.pokemonImage.af.setImage(withURL: downloadURL)
            }else{
                return self.pokemonImage.af.setImage(withURL: downloadURL) // get data from DB
                //return DDBBManager(Image.self) // [Image](with all images) -> get the one that references(with the url)
            }
            
        }else {
            return
        }
    }
}


//MARK: - Buttons methods
extension PokemonDetailsViewController{
    
    
    //MARK: - addToFavouritesPressed
    @objc func addToFavouritesPressed(_ sender: ZeroOutlineButton!) {
        if user != nil{
            guard let selectedPokemon = selectedPokemon else{return}
            if favouritesButton.titleLabel?.text == NSLocalizedString("add_to_favourites", comment: ""){
                    presenter?.addFavourite(pokemon: selectedPokemon)
            } else if favouritesButton.titleLabel?.text == NSLocalizedString("delete_from_favourites", comment: ""){
                    presenter?.deleteFavourite(pokemon: selectedPokemon)
            }
        }else{
            alert.show(
                title: NSLocalizedString("Favourites", comment: ""),
                info: NSLocalizedString("You_will_not_be_able_to_add_any_pokemons_to_favourites_until_you_login_or_sign_up_Would_you_like_to_login_or_sign_up", comment: ""),
                titleOk: NSLocalizedString("Yes", comment: ""),
                titleCancel: NSLocalizedString("No", comment: ""),
                completionOk: {
                    self.presenter?.openLoginSignUpWindow()
                },
                completionCancel: nil
            )
        }
        
    }
    
    
    //MARK: - imageTapped
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {//Pass the image
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        guard let imageToSave = tappedImage.image else{return}
        if self.saveImage(image: imageToSave) == true{
            self.presenter?.openARKitView()
        }else{
            print("Error when saving image!")
        }
        
        
    }
    
    //MARK: - nextPokemonButtonAction
    @objc func nextPokemonButtonAction(_ sender: ZeroContainedButton!){
        guard let nextPokemon = nextPokemon else{return}
        presenter?.fetchPokemon(pokemon: nextPokemon)
        if row == filtered.count - 1{ // if we're in the last row, and we press next actualRow will be the first
            row = 0
        }else{
            row = row! + 1 // if we do guard let row = row or row ?? 0 doesn't work
        }
        nextOrPrevious()
    }
    
    
    //MARK: - previousPokemonButtonAction
    @objc func previousPokemonButtonAction(_ sender: ZeroContainedButton!){
        guard let previousPokemon = previousPokemon else{return}
        presenter?.fetchPokemon(pokemon: previousPokemon)
        if row == 0{ // if we're in the first row, and we press previous actualRow will be the last
            row = filtered.count - 1
        }else{
            row = row!  - 1 // if we do guard let row = row or row ?? 0 doesn't work
        }
        nextOrPrevious()
        
    }
    
    
    //MARK: - nextOrPrevious
    func nextOrPrevious(){
        guard let row = row else{return}
        if filtered.count < 3{
            if row == 0{
                self.selectedPokemon = filtered[row]
                self.previousPokemon = filtered.last
                self.nextPokemon = previousPokemon
            }else{
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


//MARK: - Painting methods
extension PokemonDetailsViewController{
    func setName(type: String, to label : UILabel){
        switch type {
        case TypeName.normal:
            label.text = NSLocalizedString("normal", comment: "")
        case TypeName.fighting:
            label.text = NSLocalizedString("fighting", comment: "")
        case TypeName.flying:
            label.text = NSLocalizedString("flying", comment: "")
        case TypeName.poison:
            label.text = NSLocalizedString("poison", comment: "")
        case TypeName.ground:
            label.text = NSLocalizedString("ground", comment: "")
        case TypeName.rock:
            label.text = NSLocalizedString("rock", comment: "")
        case TypeName.bug:
            label.text = NSLocalizedString("bug", comment: "")
        case TypeName.ghost:
            label.text = NSLocalizedString("ghost", comment: "")
        case TypeName.steel:
            label.text = NSLocalizedString("steel", comment: "")
        case TypeName.fire:
            label.text = NSLocalizedString("fire", comment: "")
        case TypeName.water:
            label.text = NSLocalizedString("water", comment: "")
        case TypeName.grass:
            label.text = NSLocalizedString("grass", comment: "")
        case TypeName.electric:
            label.text = NSLocalizedString("electric", comment: "")
        case TypeName.psychic:
            label.text = NSLocalizedString("psychic", comment: "")
        case TypeName.ice:
            label.text = NSLocalizedString("ice", comment: "")
        case TypeName.dragon:
            label.text = NSLocalizedString("dragon", comment: "")
        case TypeName.dark:
            label.text = NSLocalizedString("dark", comment: "")
        case TypeName.fairy:
            label.text = NSLocalizedString("fairy", comment: "")
        case TypeName.unknown:
            label.text = NSLocalizedString("unknown", comment: "")
        case TypeName.shadow:
            label.text = NSLocalizedString("shadow", comment: "")
        default:
            print("DEFAULT ERROR")
        }
    }
    func paintLabel(pokemon: PokemonData){
        if pokemon.types.count >= 2{ //GRAY
            self.pokemonType2Label.isHidden = false
            self.pokemonDescriptionView.backgroundColor = UIColor(named: "grayColor")
            guard let typeName_1 = pokemon.types[1].type?.name else{return}
            guard let typeName_0 = pokemon.types[0].type?.name else{return}
            self.pokemonType2Label.text = typeName_1
            self.paintType(label: self.pokemonType1Label)
            self.paintType(label: self.pokemonType2Label)
            self.setName(type: typeName_1, to: pokemonType2Label)
            self.setName(type: typeName_0, to: pokemonType1Label)
            
            //MARK: - Views' background
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.typesView)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.backgroundView)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.nextOrPreviewView)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.statsView)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.heightAndWeightView)
            
            
            
            //MARK: - Label's background
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.pokemonIdLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.pokemonNameLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.heightLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.weightLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.statsLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.hpLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.attackLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.defenseLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.specialAttackLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.specialDefenseLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.speedLabel)
            self.pokemonIdLabel.textColor = .black
            self.pokemonNameLabel.textColor = .black
            self.heightLabel.textColor = pokemonType2Label.textColor
            self.weightLabel.textColor = pokemonType2Label.textColor
            self.statsLabel.textColor = pokemonType2Label.textColor
            self.hpLabel.textColor = pokemonType2Label.textColor
            self.attackLabel.textColor = pokemonType2Label.textColor
            self.defenseLabel.textColor = pokemonType2Label.textColor
            self.specialAttackLabel.textColor = pokemonType2Label.textColor
            self.specialDefenseLabel.textColor = pokemonType2Label.textColor
            self.heightLabel.textColor = pokemonType2Label.textColor
            self.speedLabel.textColor = pokemonType2Label.textColor
            self.paintIfAbility(pokemon: pokemon)
            self.addBorder(statsLabel)
            
            
            //MARK: - Buttons' background
            self.setBackgroundColor(from: pokemonType1Label, to: favouritesView)
            self.setBackgroundColor(from: pokemonType1Label, to: favouritesButton)
            self.favouritesButton.setTitleColor(pokemonType1Label.textColor, for: .normal)
            self.nextButton.backgroundColor = pokemonDescriptionView.backgroundColor
            self.previewButton.backgroundColor = pokemonDescriptionView.backgroundColor

            
        } else{
            self.paintType(label: self.pokemonType1Label)
            guard let typeName = pokemon.types[0].type?.name else{return}
            self.setName(type: typeName, to: pokemonType1Label)
            self.pokemonType2Label.isHidden = true
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonDescriptionView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.typesView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.backgroundView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.nextOrPreviewView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.nextButton)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.previewButton)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonIdLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonNameLabel)
            
            self.statsView.backgroundColor = UIColor(named: "grayColor")
            self.setBackgroundColor(from: self.statsView, to: self.hpLabel)
            self.hpLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.attackLabel)
            self.attackLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.defenseLabel)
            self.defenseLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.specialAttackLabel)
            self.specialAttackLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.specialDefenseLabel)
            self.specialDefenseLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.speedLabel)
            self.speedLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.statsLabel)
            self.statsLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.weightLabel)
            self.weightLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.heightLabel)
            self.heightLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.heightAndWeightView)
            self.paintIfAbility(pokemon: pokemon)
            self.addBorder(statsLabel)
            
            
            //MARK: - Buttons' background
            self.setBackgroundColor(from: statsView, to: favouritesView)
            self.setBackgroundColor(from: statsView, to: favouritesButton)
            self.favouritesButton.setTitleColor(.white, for: .normal)
            self.nextButton.backgroundColor = pokemonDescriptionView.backgroundColor
            self.previewButton.backgroundColor = pokemonDescriptionView.backgroundColor
            
            
        }
    }
    
    
    func addBorder(_ label: UILabel){
        label.layer.borderColor = label.textColor.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 5
    }
    func paintIfAbility(pokemon: PokemonData){
        if pokemon.types.count >= 2{
            if pokemon.abilities.count >= 2{
                guard let abilityName = pokemon.abilities[1].ability?.name else{return}
                self.setBackgroundColor(from: self.pokemonType2Label, to: self.ability1Label)
                self.setBackgroundColor(from: self.pokemonType2Label, to: self.ability2Label)
                self.ability1Label.textColor = pokemonType2Label.textColor
                self.ability2Label.textColor = pokemonType2Label.textColor
                self.ability2Label.text = abilityName.uppercased()
            }else{
                self.ability2Label.isHidden = true
            }
        }else{
            if pokemon.abilities.count >= 2{
                guard let abilityName = pokemon.abilities[1].ability?.name else{return}
                self.setBackgroundColor(from: self.statsView, to: self.ability1Label)
                self.setBackgroundColor(from: self.statsView, to: self.ability2Label)
                self.ability1Label.textColor = .black
                self.ability2Label.textColor = .black
                self.ability2Label.text = abilityName.uppercased()
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
        case TypeName.fighting:
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
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.fire:
            setPokemonBackgroundColor(240, 128, 48, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
        case TypeName.water:
            setPokemonBackgroundColor(104, 144, 240, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
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
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
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
            favouriteConfirmationImage.image = UIImage(named: "fullStar")
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



//MARK: - Image saving method
extension PokemonDetailsViewController{
    //MARK: - saveImage
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
