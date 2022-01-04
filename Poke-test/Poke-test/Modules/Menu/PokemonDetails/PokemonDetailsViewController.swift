
import UIKit
import AlamofireImage
import RealmSwift
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics


//MARK: - PokemonDetailsViewController
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
    var cell: PokemonCellDelegate?
    var filtered: [Results] = []
    var row : Int?
    let user = Auth.auth().currentUser
    var arrayOfNames: [String] = []
    
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
        self.loadButtonsStyle()
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
    func loadButtonsStyle(){
        self.previewButton.layer.cornerRadius = 5
        self.previewButton.layer.borderWidth = 2
        self.previewButton.layer.borderColor = UIColor.black.cgColor
        self.nextButton.layer.cornerRadius = 5
        self.nextButton.layer.borderWidth = 2
        self.nextButton.layer.borderColor = UIColor.black.cgColor
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
        self.hpLabel.text = "Hp: \(pokemon.stats[0].base_stat)"
        self.attackLabel.text = NSLocalizedString("Attack", comment: "") + "\(pokemon.stats[1].base_stat)"
        self.defenseLabel.text = NSLocalizedString("Defense", comment: "") + "\(pokemon.stats[2].base_stat)"
        self.specialAttackLabel.text = NSLocalizedString("Special_attack", comment: "") + "\(pokemon.stats[3].base_stat)"
        self.specialDefenseLabel.text = NSLocalizedString("Special_defense", comment: "") + "\(pokemon.stats[4].base_stat)"
        self.speedLabel.text = NSLocalizedString("Speed", comment: "") + "\(pokemon.stats[5].base_stat)"
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
    @objc func addToFavouritesPressed(_ sender: UIButton!) {
        if user != nil{
            guard let selectedPokemon = selectedPokemon else{return}
            if favouritesButton.titleLabel?.text == NSLocalizedString("add_to_favourites", comment: ""){
                    presenter?.addFavourite(pokemon: selectedPokemon)
            } else if favouritesButton.titleLabel?.text == NSLocalizedString("delete_from_favourites", comment: ""){
                    presenter?.deleteFavourite(pokemon: selectedPokemon)
            }
        }else{
            let alert = UIAlertController(title: NSLocalizedString("Favourites", comment: ""), message: NSLocalizedString("You_will_not_be_able_to_add_any_pokemons_to_favourites_until_you_login_or_sign_up_Would_you_like_to_login_or_sign_up", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default, handler: {(action) in
                self.presenter?.openLoginSignUpWindow()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
    
    
    //MARK: - previousPokemonButtonAction
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
        case TypeName.fight:
            label.text = NSLocalizedString("fight", comment: "")
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
        if pokemon.types.count >= 2{
            self.pokemonType2Label.isHidden = false
            guard let typeName_1 = pokemon.types[1].type?.name else{return}
            self.pokemonType2Label.text = typeName_1 //Saved the 2nd type
            self.paintType(label: self.pokemonType1Label)
            self.paintType(label: self.pokemonType2Label)
            guard let typeName_0 = pokemon.types[0].type?.name else{return}
            self.setName(type: typeName_1, to: pokemonType2Label)
            self.setName(type: typeName_0, to: pokemonType1Label)
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
                guard let ability2Name = pokemon.abilities[1].ability?.name else{return}
                self.ability2Label.text = ability2Name.uppercased() //Save the 2nd ability
                self.ability1Label.textColor = pokemonType1Label.backgroundColor
                self.ability2Label.textColor = pokemonType2Label.backgroundColor
            }else{
                self.ability2Label.isHidden = true
            }
        } else{
            self.paintType(label: self.pokemonType1Label)
            guard let typeName = pokemon.types[0].type?.name else{return}
            self.setName(type: typeName, to: pokemonType1Label)
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
                guard let abilityName = pokemon.abilities[1].ability?.name else{return}
                self.ability2Label.text = abilityName.uppercased() //Save the 2nd ability
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
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
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
